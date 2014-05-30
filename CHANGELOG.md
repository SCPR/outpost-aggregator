## 1.2.0
### Fixes
* Now you can have multiple aggregators on a single page.


## 1.1.3 (2014-03-19)
### Fixes
* Fixed a z-index issue between dropzone empty message and alerts.

### Changes
* Deprecated `dropLimit`. Replacement is `dropMaxLimit`.

### Additions
* Added `dropMinLimit` to view options to notify the user when the minimum limit isn't satisfied. (Default: 0)
* Added a `dropRejectOverflow` option to determine whether or not the aggregator should reject upper-limit overflow. (default: true)


## 1.1.2
### Fixes
* Fixed dropLimit


## 1.1.1
### Additions
* Added a `dropLimit` in the view options, for specifying the number of articles allowed in the DropZone. By default, this is "null", which means "no limit".
* Added notifications for Limit, and a limit counter
* Specify that only ".sortable" nodes should be sortable
* Added support for Singular associations. Your `build_association` method should
  just set the association via `self.content = content`.

### Changes
* Removed old Secretary hooks.
* All Outpost object now have a "simple_json" method, which just returns a
  hash with the ID. This should be overridden in most cases.


## 1.1.0
Yanked


## 1.0.0
* The method to use is now `accepts_json_input_for`, and requires 
  a single argument: the name of the association.
* Does not do a `published?` check anymore. That's up to you to check when
  building the association.
* Method to specify how to build the association is now 
  `build_#{name.singularize}_association`. For example, if you have 
  `accepts_json_input_for :assets`, then you should define 
  `build_asset_association`. This is where you should do any validations
  on the content - `published?`, `persisted?`, etc.


## v0.1.1
* Merge in the passed-in params (such as api token) to the params for 
  "by_url" requests. This allows one to use their internal/private API
  with the by_url requests.
