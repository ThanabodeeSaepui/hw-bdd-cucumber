# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  n1 = 0 # index position of e1
  n2 = 0 # index position of e2
  td = page.find(:xpath, './/table[@id="movies"]').all(:xpath, '//td')
  td.each_with_index do |item,index|
    if item.text(:all) == e1
      n1 = index # set index of e1 to n1
    end
    if item.text(:all) == e2
      n2 = index # set index of e2 to n2
    end
  end
  n1.should < n2 # should find e1 before e2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck.nil?
    rating_list.split(',').each do |rating|
      step "I check \"ratings[#{rating}]\""
    end
  else
    rating_list.split(',').each do |rating|
      step "I uncheck \"ratings[#{rating}]\""
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  n = page.find(:xpath, './/table[@id="movies"]').all(:xpath, '//tr').count - 1
  n.should == Movie.count
end
