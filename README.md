# Setting up

How to setup nr1 after you have cloned this repo:

1. **set a new rails secret.** Copy `config/secrets.yml.example` to `config/secrets.yml`, and in `config/secrets.yml` run `rails secret`, copy and paste to development and testing.

2. **config to your instance of postgres** Edit copy `config/database.yml.example` to `config/database.yml`. If you use the [Postgres App](http://postgresapp.com/) on mac os, you are good to go. If not, change values to what works for you.

3. **Run bundler:** `bundle exec bundle`

4. **Initialize your postgres db:** `bundle exec rake db:setup` or if your instance of Postges does not like db:setup, `bundle exec rake db:create` and then `bundle exec rake db:migrate`and then `bundle exec rake db:seed`.

5. **Run the application**: `rails s`

6. **Test the application**: `bundle exec rake test`
Output should look like:

```
Bobs-iMac-3:nr1 bobwalsh$ bundle exec rake test
Run options: --seed 32772

# Running:

...........

Finished in 0.436237s, 25.2157 runs/s, 48.1390 assertions/s.

11 runs, 21 assertions, 0 failures, 0 errors, 0 skips
```


