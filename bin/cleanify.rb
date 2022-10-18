#!/usr/bin/env ruby -i
# encoding: utf-8

# Usage:
# find . | egrep '\.rb$' | egrep -v cleanify.rb | xargs ./bin/cleanify.rb

# \n at the end of the file
# def foo a, b, &block
# no trailing whitespace
# encoding declaration

ENCODING = "utf-8"

while line = ARGF.gets
  # whitespace
  # line.chomp!
  line.gsub!(/\t/, "  ")
  line.rstrip!

  # encoding
  if line.length == (ARGF.pos - 1) && ! line.match(/^#.*coding/)
    puts "# encoding: #{ENCODING}\n\n"
  end

  # def
  regexp = /^(\s*def \w[\w\d]*)\s+(.+)$/
  if line.match(regexp)
    line.gsub!(regexp, '\1(\2)')
  end

  # foo{} => foo {}
  line.gsub!(/([^%][^#( ])(\{)/, '\1 \2')

  # a=foo => a = foo
  line.gsub!(/([^ ])(\+=)/, '\1 \2')
  line.gsub!(/(\+=)([^ ])/, '\1 \2')
  line.gsub!(/([^ :])(<<)/, '\1 \2')
  line.gsub!(/(<<)([^ ])/, '\1 \2')

  # foo=>bar
  line.gsub!(/([^\s])=>/, '\1 =>')
  line.gsub!(/=>([^\s])/, '=> \1')

  line.gsub!(/\{\|/, '{ |')

  line.gsub!(/,\s*/, ', ')
  line.rstrip!

  puts line
end
