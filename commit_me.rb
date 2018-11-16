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
      puts "current branch not found, backing up to master"
      return "master"
    end
  end
end


def backup(first_or_not, current_branch)
  if first_or_not == "first"
    system("git checkout -b backup &&  git add . && git commit -m 'automated backup' && git checkout #{current_branch}")
  else
    system("git checkout backup &&  git add . && git commit -m 'automated backup' && git checkout #{current_branch}")\
  end
end

# on first run, determine current branch, create backup branch, add commit,
# then switch back to previous branch
current_branch = check_branch()
backup("first", current_branch)

while true
  # generate random number of minutes between 10 and 20
  # backup_interval = 600 + (Math.random * 60 * 20)
  backup_interval = 5 + (Math.random * 5)
  sleep(backup_interval)
  puts "--------------------------------------------------------------"
  puts "--------------------------------------------------------------"
  puts "backing up......"
  puts "timestamp: " + time.now()
  current_branch = check_branch()
  puts "current branch: " + current_branch
  backup(false, current_branch)
  puts "backup complete"
  puts "--------------------------------------------------------------"
  puts "--------------------------------------------------------------"
end
