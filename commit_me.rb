#!/usr/bin/env ruby

# Navigate to the root of your project directory and run this script. It will
# create a branch called "backup" and randomly (every 20-30 minutes) switch to,
 # stage and commit all of your changes (unless they are added to your .gitignore).
# It will then switch back to your current branch.

def check_branch

  branches = %x(git branch)
  branches_array = branches.split("\n")

  branches_array.each do |each|
    branch = each.split(" ")
    if branch.include?("*")
      branch = branch - ["*"]
      branch = branch.join
      puts "current branch = " + branch
      return branch
    else
      puts "current branch not found, backup failed"
      return false
    end
  end

end

# on first run, determine current branch, create backup branch, add commit,
# then switch back to previous branch
current_branch = check_branch()
system("git checkout -b backup &&  git add . && git commit -m 'automated backup' && git checkout #{current_branch}")
