#!/usr/bin/env python3
"""
web cache and tracker
"""

import requests
import redis
from functools import wraps

# Initialize Redis connection
store = redis.Redis()

def cache_page(method):
    """ Decorator to cache the HTML content of a URL and track access count """
    @wraps(method)
    def wrapper(url: str) -> str:
        cached_key = f"cached:{url}"
        cached_data = store.get(cached_key)
        if cached_data:
            return cached_data.decode("utf-8")
        
        # If not cached, proceed to fetch the page
        html = method(url)

        # Increment the access count for the URL
        count_key = f"count:{url}"
        store.incr(count_key)

        # Cache the HTML content with an expiration of 10 seconds
        store.setex(cached_key, 10, html)

        return html
    return wrapper

@cache_page
def get_page(url: str) -> str:
    """Fetches the HTML content of a URL."""
    response = requests.get(url)
    return response.text
