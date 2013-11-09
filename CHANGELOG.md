## 2.0.0 (unreleased)
#### Changes
* Add support for Secretary 1.0.0


## 1.0.0 (2013-06-13)
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
