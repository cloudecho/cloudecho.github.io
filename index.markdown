---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: post
---

<!-- Html Elements for Search -->
<div id="search-container">
  <input class="post-link" style="color: #828282; width:100%;" type="text" id="search-input" placeholder="search...">
  <ul class="post-list" id="results-container"></ul>
</div>

<!-- Script pointing to search-script.js -->
<script src="/js/simple-jekyll-search.min.js" type="text/javascript"></script>

<!-- Configuration -->
<script>
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json'
})
</script>

<br>

<!-- Display latest 5 posts -->
<ul class="post-list">
    {% for post in site.posts limit: 5 %}
    <li><span class="post-meta">{{ post.date }}</span>
        <a class="post-link" href="{{ site.baseurl }}{{ post.url }}">
        {{ post.title }}
        </a>
    </li>
    {% endfor %}
</ul>

<p class="rss-subscribe">subscribe <a href="/feed.xml">via RSS</a></p>