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
```
Search is case sensitive and checks for strict equality. Only one search condition allowed.

When condition is for an attribute which values are arrays, search works in this way:
 - if the value in the search query is an array, it searches for items that have _this array exactly_ in the attribute, although the order of elements is not important;
 - if the value in the search query is not an array (i.e string) the search includes an item into the results if the array contains the searched value.

The app prints the results in the console as formatted JSON.

### How It Works & Ideas Behind the Implementation

Each JSON file is loaded into a collection, which items get indexed in inverted indices for faster lookup. Thus startup time may be longer on large datasets, but search will be fast.

All collections and associations between them are held within a Dataset.
The structure of the dataset is described in “schema.json” and loaded and interpreted by the app.
Dataset has “search” method that accepts Query objects that are constructed from the user input.
From those Query objects, the Dataset can understand which Selector to create to perform search.
Selectors contain logic for how exactly to get items from a collection using its indices according to the instructions from the Query object.
Items selected by selectors get associations added to them by the Dataset (since it knows about associations).

Implementation is optimised for performance and extensibility.

As for performance, it is using inverted indexes on each field of an item.
Because of that, items can be found in two lookups without scanning entire collections.
That should scale much better than linearily.

As for extensibility, it is possible to change the data format for input data, add more types of entities, add more associations between them, add more search conditions (>, >=, <, =<, like, etc), make search case-insensitive, change the user interface.

What would be nice to add (but I decided not to add to avoid overcomplicating implementation further):
- search by checking if array attributes contains one or more values,
- add more search operators (like, >, >=, etc),
- add option to do case insensitive search,
- allow to use AND or OR in queries

### Note
Hopefully the implementation is not overcomplicated.
I wanted to make it extensible and that naturally leads to having many small classes with narrow responsibilities.
