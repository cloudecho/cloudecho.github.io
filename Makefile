default: push publish

push:
	git push

publish:
	mkdocs gh-deploy --force
