#!/usr/bin/env ruby
require 'fileutils'

puts '----------------------------------------------------------------------------'
puts ' This script will create your project as a sibling to this directory.'
puts '                           It will:'
puts ' 1. Ask the name of your project and create a directory for it.'
puts ' 2. Create your lib/ and spec/ subdirectories.'
puts ' 3. Add a Gemfile including rspec, pry and pivotal_git_scripts (if needed).'
puts ' 4. Run bundle to install your Gems.'
puts ' 5. Add a .gitignore and initial commit to ignore the Gemfile.lock.'
puts ' 6. Allow you to make unlimited classes (or none) then give each their own file.'
puts ' 7. Add specs to your spec file for each class you entered'
puts ' 8. Run "git add ." and commit the changes confirming your environment is setup.'
puts '----------------------------------------------------------------------------'
puts '           What would you like to call your project?'
puts '----------------------------------------------------------------------------'
print ': '

# Create project directory and declare variables for I/O
project_name = gets.chomp
project_root = '../' + project_name

FileUtils.mkdir_p project_root + '/lib/'
FileUtils.mkdir_p project_root + '/spec/'
FileUtils.mkdir_p project_root + '/public/'
FileUtils.mkdir_p project_root + '/views/'
system('cp ' + './README.template ' + project_root + '/README.md')


FileUtils.touch project_root + '/Gemfile'
gemfile = File.open(project_root + '/Gemfile', 'a')

FileUtils.touch project_root + '/.gitignore'
git_ignore = File.open(project_root + '/.gitignore', 'a')
git_ignore.write("*.lock")

puts '-------------------------------------------------------------------------------'
puts '-------------------------------------------------------------------------------'
puts 'Git repo initialized and "*.lock" added to ' + project_root + '/.gitignore'
puts '-------------------------------------------------------------------------------'
puts '-------------------------------------------------------------------------------'

system('cd ' + project_root + ' && git init && git add . && git commit -m "initial commit" && cd ..')

FileUtils.touch project_root + '/spec/ruby_spec.rb'
project_spec_file = File.open(project_root + '/spec/ruby_spec.rb', 'a')


# Gemfile creation and Gem install
puts '-------------------------------------------------------------------------------'
puts '-------------------------------------------------------------------------------'
puts 'How many people will commit to this project? '
puts '-------------------------------------------------------------------------------'
puts '-------------------------------------------------------------------------------'
print ': '
contributors = gets.chomp

gemfile.write("source 'https://rubygems.org'\n")
gemfile.write("\n")
gemfile.write("gem 'sinatra'\n")
gemfile.write("gem 'rspec'\n")
gemfile.write("gem 'pry'\n")
if contributors == "2"
  gemfile.write("gem 'pivotal_git_scripts'\n")

  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'What are the initials of the FIRST person? '
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  print ': '
  contrib_1_initials = gets.chomp

  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'What are the initials of the SECOND person? '
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  print ': '
  contrib_2_initials = gets.chomp
end
gemfile.close()
system('cd ' + project_root + ' && bundle')


# Ask questions about the project and configure project folder
classes_to_make = []
print 'Would you like to add any classes? (y/n) :'
answer = gets.chomp
while answer == 'y'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'Please enter a class to be used in your program:.'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  print ': '
  classes_to_make.push(gets.chomp)

  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'Would you like to add another class? (y/n).'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  print ': '
  answer = gets.chomp
end
if classes_to_make.length > 0
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'Creating classes: '
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'

  classes_to_make.each do |input_class|
    project_file = File.open(project_root + "/lib/#{input_class}.rb", 'a')
    project_file.write("class " + input_class + "\n\nend\n\n\n")
    puts "#{input_class} class added"
    project_file.close()
  end
  puts '-------------------------------------------------------------------------------'
  puts 'done'
  puts '-------------------------------------------------------------------------------'

else
  FileUtils.touch project_root + '/lib/ruby.rb'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'No classes will be created...'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
end


# Create spec file and fill with example spec for classes

project_spec_file.write("require ('rspec')\nrequire ('pry')\n")


if classes_to_make.length > 0
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts 'Creating class specs .'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'

  classes_to_make.each do |input_class|
    project_spec_file.write("require ('#{input_class}')\n")
  end
  project_spec_file.write("\n\n")

  classes_to_make.each do |input_class|
    project_spec_file.write("describe('#{input_class}') do \n\n  it('tests a method for #{input_class}') do\n\n    dummy = #{input_class}.new()\n\n    expect(dummy.method()).to(eq(expected result))\n\n  end\n\nend\n\n")
    puts "#{input_class} spec added"
  end
  project_spec_file.close()
  puts '-------------------------------------------------------------------------------'
  puts 'done'
  puts '-------------------------------------------------------------------------------'

else
  project_spec_file.write("require ('ruby')")
  project_spec_file.close()
  puts '-------------------------------------------------------------------------------'
  puts 'No classes declared. Generic ruby.rb file and spec file created.'
  puts '-------------------------------------------------------------------------------'

end


# Initialize git repository and ask for repo link
if contributors == "2"
  system('cd ' + project_root + ' && git pair ' + contrib_1_initials + ' ' + contrib_2_initials + ' && git add . && git-pair-commit -m "complete environment setup"')
else
  system('cd ' + project_root + ' && git add . && git commit -m "complete environment setup"')
end

  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
  puts '                                  COMPLETE'
  puts '-------------------------------------------------------------------------------'
  puts '-------------------------------------------------------------------------------'
