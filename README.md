# Alexander Volfovsky Website

Source for <https://volfovsky.github.io>, built with Jekyll and hosted by GitHub Pages.

## Local Development

Install dependencies:

```sh
bundle install
```

Build the site:

```sh
bundle exec jekyll build
```

Run a local server:

```sh
bundle exec jekyll serve
```

## Updating the CV

The public CV lives at `files/CV_Volfovsky.pdf`. To replace it from a local PDF:

```sh
scripts/update_cv.sh /path/to/current_cv.pdf
```

The `/cv/` page is intentionally hidden from the top navigation for now, but remains public.
