# StripeReporter

This is a tool for writing simple reports on top of Stripe's SQLite export.

## Getting Started

First, you need to request and be granted access to the beta. Instructions for doing so are in the [Stripe API Announce thread](https://groups.google.com/a/lists.stripe.com/forum/#!topic/api-discuss/x2VXdVdn66w).

Next, fork this repo, download your export file from your Stripe dashboard, then:

```bash
$ git clone https://github.com/YOURUSERNAME/stripe_reporter.git
$ cd stripe_reporter
$ bundle install
$ STRIPE_DATA_FILE=/path/to/your/data/file.db
```

Now navigate to https://localhost:9292. You'll see some very basic reports on the dashboard.

## Writing Reports

Reports are just `erb` files in the `views/reports` directory. StripeReporter provides some useful helpers

### Queries

The `query` helper is a block helper that wraps a SQL query. For example:

```rhtml
<%= @query = query do %>
  select
    count(1) as "Charge Count"
  from
    charges
<% end %>
```

This assigns the generated query object to the `@query` variable.

You can refer to HTTP query params using this syntax: `:query_param_name`. For example:

```rhtml
<%= @query = query do %>
  select
    count(1) as "Charge Count"
  from
    charges
  where
    currency = :currency
<% end %>
```

### Tables

The `table` helper dumps a query from the `query` helper into an HTML table.

```rhtml
<%= table @query %>
```

The `table` helper takes an optional block that lets you do things like add links to other reports and other decorators. Here's how you add a link:

```rhtml
<%= table @query do |t|
      t.link /Charge Count/ => '/reports/charges'
    end %>
```
The first argument is a regular expression that should match a column name. The second argument after the fat arrow is the URL to link to.

The URL can include references to other columns in the current row using this syntax: `:n`, where `n` is the zero-based index of the column, You can also use `:this` to refer to the column value that you are currently decorating, and `:now` to give the current date.

### Decorators

StripeReporter is built on top of [Sequel::Reporter](https://github.com/peterkeen/sequel-reporter/) and includes a few other decorators, which you can read [in the source](https://github.com/peterkeen/sequel-reporter/blob/master/lib/sequel-reporter/decorators.rb). 
Applying other decorators is easy:

```rhtml
<%= table @query do |t|
      t.decorate /Charge Count/ =>
         Sequel::Reporter::HighlightDecorator.new('red'),
         :if => lambda { |cell,row| cell.value > 100 }
    end %>
```

The first argument is again a regular expression to match against the column name. The second argument is an instance of a decorator. You can pass an optional `:if` lambda to evaluate against each candidate cell. The lambda is passed the current cell, along with the current row.

Custom decorators should follow the pattern of the stock decorators. You can stick them in the `lib` directory, where everything gets autoloaded at startup.

## Contributing

1. Fork the project
2. Write an interesting report, decorator, or whatever
3. Create a pull request

## TODO

* Graphs and charts
* More interesting reports
* Upgrade to a less-ancient version of Bootstrap
