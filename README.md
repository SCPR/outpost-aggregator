# Outpost::Aggregator

Provides UI and server-side handling for building associations between
any two objects.

## Installation

    gem 'outpost-aggregator'

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

```ruby
<div id="aggregator" class="aggregator"></div>
<%= f.input :content_json, as: :hidden, input_html: { id: "content_json" } %>

<script>
    aggregator = new outpost.Aggregator(
      "#aggregator", "#content_json",
      <%= j record.content.includes(:content).map(&:content).to_json.html_safe %>, 
      <%= raw options.to_json %>);
</script>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
