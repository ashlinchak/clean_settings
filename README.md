# CleanSettings

CleanSettings - it's simple and clean settings for your Rails project.

## Requirements
For version 1.1.2:
* Ruby 1.9.3
* Rails 3.2.22

For version 1.1.1:
* Ruby 2.0.0
* Rails 4.0.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clean_settings'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install clean_settings
```

Run a generator:

```bash
rails g clean_settings:install
```

## Usage

After installattion you will have a CleanSettings::Setting active_record model. If you want to extend this model you can use inheritance:

```ruby
class CleanSettings < CleanSettings::Setting
```

#### Default settings

If you need default settings for your Rails project you can add ruby file to config/initializers folder. Personally I prefer to name it as **default_settings.rb**. And fill this file with settings that you need:
```ruby
CleanSettings.defaults.project_name = "name"
CleanSettings.defaults.project_key = 123456789
CleanSettings.defaults.configs = { time: "UTC", currency_code: 980 }
```
After restart your project you will be able to get you defaults settings:
```ruby
CleanSettings.defaults.project_name # =>  "name"
CleanSettings.project_name      # =>  "name"
```
Get all defaults settings in hash with indifferent access :

```ruby
CleanSettings.all_defaults  
```

Clearing default settings.

```ruby
CleanSettings.clear_defaults
```

Default settings are not saved to DB. Because they are 'defaults'. That's why when you clear default settings it will clear them only for current session. When your app is restarted, your default settings will be returned according your **default_settings.rb** file.

#### Global settings

For adding and getting settings that will be available anywhere in your project you can write like this:
```ruby
# set
CleanSettings.project_name = "name"

# get
CleanSettings.project_name  # => "name"
```
If you prefer an array notation:
```ruby
# set
CleanSettings[:project_name] = "name"

# get
CleanSettings[:project_name]  # => "name"
```
When you adding a setting with the name that was used for default setting  you override default setting:

```ruby
CleanSettings.defaults[:name] = "default name"
CleanSettings.name    # => "default name"

CleanSettings.name = "another name"
CleanSettings.name  # => "another name"
```

Get all global settings in hash with indifferent access

```ruby
CleanSettings.all_globals  
```

##### Get all settings
All settings (default and global) you can get through any of these methods:

```ruby
CleanSettings.all_settings
# or
CleanSettings.fetch
```
Global settings will be merged with default settings.

#### Ownerable settings

Often you need specific settings for an object. With **CleanSettings** simple add a :has_settings method to you model:

```ruby
class User < ActiveRecord::Base
  has_settings
end
```
And use it:

```ruby
@user = User.new
@user.settings.subscribe_to_notifications = true
@user.settings.subscribe_to_notifications # => true
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ashlinchak/clean_settings.
