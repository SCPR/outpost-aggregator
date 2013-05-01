# Outpost::Aggregator

Provides UI and server-side handling for building associations between
any two objects.

## Installation

    gem 'outpost-aggregator'


## Dependencies

This is a pretty simple gem... you can probably get away with using this gem without Outpost, so I won't include it as a hard dependency, but I also won't support this usage. You'll just need to define a few methods (`obj_key`, `published?`), and setup the `window.outpost = {}` object before you include the aggregator scripts.


## Usage

The aggregator writes a JSON string to a hidden input, and that's
what gets submitted to and parsed by the server.

In your model:

```ruby
has_many :content, class_name: "PostContent", order: "position", dependent: :destroy
accepts_json_input_for_content
```

You can provide a `name` option to the `accepts_json_input_for_content` method if the association is named something different.

In the form, you need to provide a div for the aggregator to be built in,
the hidden input for the JSON string, and then initialize the Aggregator with
bootstrapped content. Using simple_form, and assuming the record's association
is called "content" (which is the default), it might look like this:

```erb
<div id="aggregator" class="aggregator"></div>
<%= f.input :content_json, as: :hidden, input_html: { id: "content_json" } %>

<script>
    aggregator = new outpost.Aggregator(
      "#aggregator", "#content_json",
      <%= j record.content.includes(:content).map(&:content).to_json.html_safe %>, 
      <%= raw options.to_json %>);
</script>
```

You should also define an `outpost.ContentAPI`, which should look something like this:

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
