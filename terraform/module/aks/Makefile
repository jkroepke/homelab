.PHONY: clean generate

clean:
	rm -rf *.tf

generate: clean
	cat source.json | gomplate -t source/_helper.tmpl -d defaults=./source/_defaults.yaml -d terraform=stdin:///in.json --exclude _* --exclude README.md --input-dir=source --output-map='{{ .in | strings.ReplaceAll ".tf.tmpl" ".tf" }}'

format:
	terraform fmt -recursive .

docs:
	terraform-docs markdown table . --sort --sort-by required --output-file README.md

all: clean generate format docs
