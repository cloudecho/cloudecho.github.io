#source ~/workpython/venv/bin/activate
PLUGIN_NAMES = git-revision-date \
 awesome-pages \
 minify \
 rss

MKDOCS_PLUGINS = $(foreach p, $(PLUGIN_NAMES), mkdocs-$(p)-plugin)

default: push publish

push:
	git push

# publish:
# 	mkdocs gh-deploy --force

mkdocs:
	pip install --upgrade mkdocs-material
	pip install --upgrade $(MKDOCS_PLUGINS)

run:
	mkdocs serve