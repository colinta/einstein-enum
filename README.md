# Einstein-enum

This is a port of Swift's Enum type.  In Swift, Enums have all sorts of great
features, like associated values and raw values.  GENIUS.

They are truly awesome, unlike generics, terrible compilation error messages,
and the rather pedantic `init` method requirements.


# Compatibility

I wrote this for use in RubyMotion, but I wrote it in a way that it is
compatible with all Ruby implementations (that I know of!).


## Usage

```ruby
class Api < Enum
  value :Status
  value :Posts, raw_value: :posts
  # these represent an endpoint for "user detail", either by id or username
  value :User, Fixnum
  value :User, String

  def url
    # inside this method, the constants "Status" and methods "User" are defined
    # to return the appropriate enum values/matchers
    case self
    when Status
      "/status"
    when User(-1)  # one off values can be matched!
      "/users/by_role/admin"
    when User(Fixnum)
      # you can access the values using array access
      id = self[0]
      "/users/by_id/#{id}"
    when User(String)
      username = self[0]
      "/users/by_name/#{username}"
    when Posts
      "/posts"
    else
      nil
    end
  end

end


status_endpoint = Api.Status
user_endpoint = Api.User(2)  # if you tried `Api.User` you would get a 'value not defined' expection


# matching is really where it's at:
case status_endpoint
# simple enum values
when Api.Status
when Api.Posts
# here is the cool "polymorphic" matching.  I have not seen any other Ruby Enum
# gems offer this:
when Api.User(Fixnum)
when Api.User(String)
end


# the ability to have methods associated with the enum values is very handy, and
# adds object-oriented ideas to the boring old 'enum' type.
puts status_endpoint.url  # => https://api.api.com/api/v1/status
```

## Testing

```
rake spec
```

## Todo

It would be neat to have "named" values, instead of just positional.

```ruby
class Api < Enum
  value :User, id: Fixnum
end

user_endpoint = Api.User(id: 2)

id = user_endpoint[:id]
id = user_endpoint.id
```

Using Einstein-enum, I'd like to build a [Moya][]-like tool for RubyMotion


[Moya]: https://github.com/ashfurrow/Moya
