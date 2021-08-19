---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
{%- include search.html -%}

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