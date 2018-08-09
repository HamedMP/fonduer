TESTDATA=tests/input

dev:
	pip install -r requirements-dev.txt
	pip install -e .
	pre-commit install

test: dev check
	pytest tests -v -rsXx	

check:
	isort -rc -c fonduer/
	isort -rc -c tests/
	black fonduer/ --check
	black tests/ --check
	# This is our code-style check. We currently allow the following exceptions:
	#   - E731: do not assign a lambda expression, use a def
	#   - W503: line break before binary operator
	#   - E741: do not use variables named ‘l’, ‘O’, or ‘I’
	#   - E203: whitespace before ‘:’
	flake8 fonduer/ --count --max-line-length=88 --statistics --ignore=E731,W503,E741,E203
	flake8 tests/ --count --max-line-length=88 --statistics --ignore=E731,W503,E741,E203

docs:
	sphinx-build -b html docs/ _build/html

clean:
	pip uninstall fonduer
	rm -rf fonduer.egg-info
	rm -rf _build/

.PHONY: dev test clean check docs
