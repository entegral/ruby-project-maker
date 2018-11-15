#!/usr/bin/env ruby
require 'fileutils'

# Create project directory and declare variables for I/O
puts '---------------------------------------------------------------------'
puts 'This script will create your project in the directory it is ran in!'
puts '          What would you like to call your project? '
puts '---------------------------------------------------------------------'
project_name = gets.chomp
project_root = '../' + project_name

lib_path = FileUtils.mkdir_p project_root + '/lib/'
spec_path = FileUtils.mkdir_p project_root + '/spec/'

FileUtils.touch project_root + '/Gemfile'
gemfile = File.open(project_root + '/Gemfile', 'a')

FileUtils.touch project_root + '/.gitignore'
git_ignore = File.open(project_root + '/.gitignore', 'a')
git_ignore.write("*.lock")

puts '-------------------------------------------------------------------------------'
puts 'Git repo initialized and *.lock files added to ' + project_root + '/.gitignore'
puts '-------------------------------------------------------------------------------'

system('cd ' + project_root + ' && git init && git add . && git commit -m "initial commit" && cd ..')


FileUtils.touch project_root + '/lib/ruby.rb'
project_file = File.open(project_root + '/lib/ruby.rb', 'a')

FileUtils.touch project_root + '/spec/ruby_spec.rb'
project_spec_file = File.open(project_root + '/spec/ruby_spec.rb', 'a')


# Gemfile creation and setup
puts '.................................................'
puts 'How many people will commit to this project? '
puts '.................................................'
contributors = gets.chomp

gemfile.write("source 'https://rubygems.org'\n")
gemfile.write("\n")
gemfile.write("gem 'rspec'\n")
gemfile.write("gem 'pry'\n")
if contributors == "2"
  gemfile.write("gem 'pivotal_git_scripts'\n")
  puts '.................................................'
  puts 'What are the initials of the FIRST person? '
  puts '.................................................'
  contrib_1_initials = gets.chomp
  puts '.................................................'
  puts 'What are the initials of the SECOND person? '
  puts '.................................................'
  contrib_2_initials = gets.chomp
end
gemfile.close()
system('cd ' + project_root + ' && bundle')


# Ask questions about the project and configure project folder
classes_to_make = []
print 'Would you like to add any classes? (y/n) '
answer = gets.chomp
while answer == 'y'
  puts '.................................................'
  puts 'Please enter a class to be used in your program:.'
  puts '.................................................'
  classes_to_make.push(gets.chomp)
  puts '............................................'
  puts 'Would you like to add another class? (y/n).'
  puts '............................................'
  answer = gets.chomp
end
if classes_to_make.length > 0
  puts '..................'
  puts 'Creating classes: '
  puts '..................'

  classes_to_make.each do |input_class|
    project_file.write("class " + input_class + "\n\nend\n\n\n")
    puts "#{input_class} class added"
  end
  project_file.close()
else
  puts '..............................'
  puts 'No classes will be created...'
  puts '..............................'
end


# Create spec file and fill with example spec for classes

if classes_to_make.length > 0
  puts '......................'
  puts 'Creating class specs .'
  puts '......................'

  classes_to_make.each do |input_class|
    project_spec_file.write("describe('#{input_class}') do \n\n  it('tests a method for #{input_class}') do\n\n    dummy = #{input_class}.new()\n\n    expect(dummy.method()).to(eq(expected result))\n\n  end\n\nend\n\n")
    puts "#{input_class} spec added"
  end
  project_spec_file.close()

end


# Initialize git repository and ask for repo link
if contributors == "2"
  system('cd ' + project_root + ' && git pair ' + contrib_1_initials + ' ' + contrib_2_initials + ' && git add . && git-pair-commit -m "complete environment setup"')
else
  system('cd ' + project_root + ' && git add . && git commit -m "complete environment setup"')
end
