# Convert a ZooTool export file to JSON

## What it does

[ZooTool][zt] will be shutting down soon. I exported my
bookmarks and wanted to convert the HTML file to some fine JSON.
  
  [zt]: http://zootool.com

It’s pretty rough, but `ZooParser` does exactly that.

## What it doesn’t do

It currently ignores descriptions for bookmarks since I didn’t
really use them and they were a mess. I would be happy to merge a
pull request for that.

## Usage

First, install the dependencies:

```bash
bundle
```

Then run the script:

```bash
ruby zoo_parser.rb your_export_file.html
```

This will dump all your bookmarks to a file in the current directory
called `zoo_export_timestamp.json` (the timestamp being your current)
time.

### Performance

I exported about 1.5k bookmarks and tested it with about 6k without
running into performance issues.

## Contributing

1. Fork the repository
2. Create feature branch `git checkout -b my-new-feature`
3. Add your changes
4. Push changes `git push -u origin my-new-feature`
5. Submit a pull request
