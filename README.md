# Outpost::Aggregator

Provides UI and server-side handling for building associations between
any two objects.

## Installation

    gem 'outpost-aggregator'


## Dependencies

This is a pretty simple gem... you can probably get away with using this gem without Outpost. Just be sure you have a few things setup:

* A client-side `window.outpost` object for the javascript.
* `Outpost.obj_by_key` - to find an object by the passed-in object key.
  This is defined in outpost.
* The join model must respond to `position` and `obj_key` if you want to
  use the SimpleJson module. This module is dead-simple, so you definitely
  could just copy and paste its contents into your model and customize it
  there.


## Usage

The aggregator writes a JSON string to a hidden input, and that's
what gets submitted to and parsed by the server.

In your model:

```ruby
class Post < ActiveRecord::Base
  has_many :related_posts, order: "position", dependent: :destroy
  accepts_json_input_for :related_posts
end
```

In the form, you need to provide a div for the aggregator to be built in,
the hidden input for the JSON string, and then initialize the Aggregator with
bootstrapped content. Using simple_form, and assuming the record's association
is called "content" (which is the default), it might look like this:

```erb
<div id="aggregator" class="aggregator"></div>
<%= f.input :related_posts_json, as: :hidden, input_html: { id: "related_posts_json" } %>

<script>
    aggregator = new outpost.Aggregator(
      "#aggregator", "#related_posts_json",
      <%= j record.related_posts.includes(:post).map(&:post).to_json.html_safe %>, 
      <%= raw options.to_json %>);
</script>
```

You should also define an `outpost.ContentAPI`, to tell the Aggregator how to get in touch with your server.

```coffee
class outpost.ContentAPI

    #-----------------------------

    class @Content extends Backbone.Model
        #----------
        # simpleJSON is an object of just the attributes
        # we care about for SCPRv4. Everything else will
        # filled out server-side.
        simpleJSON: ->
            {
                id:       @get 'id'
                position: @get 'position'
            }
    
    #-----------------------------
    
    class @ContentCollection extends Backbone.Collection
        url: "/api/content/"
        model: ContentAPI.Content
            
        #----------
        # Sort by position attribute
        comparator: (model) ->
            model.get 'position'
        
        #----------
        # An array of content turned into simpleJSON. See
        # Content#simpleJSON for more.
        simpleJSON: ->
            contents = []
            @each (content) -> contents.push(content.simpleJSON())
            contents

    #-----------------------------
    
    class @PrivateContentCollection extends @ContentCollection
        url: "/api/private/content"
        
    #-----------------------------
```

Your API should have a `by_url` path, and should accept query params for 
the search and URL import to work.

See the `content_full` and `content_small` templates to see what the aggregator
expects the response object to look.


## TODO
* Write tests


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
