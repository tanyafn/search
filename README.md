## Snoopy App: almost-elasticsearch app 🐶

### Prerequisites

- Ruby (2.6.3)
- RSpec (3.9+)

### How To Run
```
  ruby ./app.rb    # Runs app
  rspec            # Runs all specs in spec directory
  rubocop          # Runs quality checks
```

Use commands like
```
select tickets where assignee_id = 2
```
to run search from the command line.
The format is
```
select <tickets|users|organizations> where <attribute_name> = <number|boolean|string>)
select <tickets|users|organizations> where <attribute_name> > <number|string>)
```
Search is case sensitive and checks for strict equality. Only one search condition allowed.

When condition is for an attribute which values are arrays, search works in this way:
 - if the value in the search query is an array, it searches for items that have _this array exactly_ in the attribute, although the order of elements is not important;
 - if the value in the search query is not an array (i.e string) the search includes an item into the results if the array contains the searched value.

The app prints the results in the console as formatted JSON.

### How It Works & Ideas Behind the Implementation

Each JSON file is loaded into a Collection object. Each item in a Collection is indexed in inverted indices (one index per item attribute) for faster lookup. That means the startup time may be longer on large datasets, but search will be fast.

A Dataset contains Collections and Associations between them. The Dataset object is configured "on the fly" with a simple DSL that allows to define collections & associations.
Dataset has `search` method that accepts Query objects constructed from the user input.
Using the properties of Query objects, the Dataset can understand which Selector to use to perform search.
Selectors contain the specific logic for fetching the items from a collection using its indices according to the instructions in the Query object.
Once items are selected from the collection, the Dataset adds the associated object since it knows about associations.

Implementation is optimised for performance, extensibility, simplicity, robustness, test coverage, usability.

As for performance, it is using inverted indexes on each field of an item. Because of that, items can be found efficiently. For example, using two lookups when searching by equality or using index scan and then index lookup. That should scale much better than linearily.

As for extensibility, it is possible to:
- add more formats for input data from JSON to XML or CSV,
- add more types of entities i.e. Comments on Tickets with associations between them,
- add more search operators (>, >=, <, =<, like, etc),
- make search case-insensitive,
- replace the interactive user interface with command-line interface.

As for simplicity:
- the dataset is configured with a simple DSL that defines collections and associations between them in a human-friendly way,
- the code is split into many small classes with a single responsibility (or few responsibilities) that are easy to reason about,

As for robustness, the app handles errors in user input and input files to produce meaningful error messages and recover if possible (with invalid user input).

As for test coverage, the app has unit tests and an integration spec.

As for usability, the app
- can be started with a single command,
- displays has built-in help,
- uses an SQL-like basic query language to define search queries.
