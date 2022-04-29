# frozen_string_literal: true

require 'optparse'
require_relative 'standard_fomat'
require_relative 'long_fomat'

class Ls
  COLUMN_NUM = 3

  def initialize(params)
    @params = params
  end

  def run
    file_paths = Dir.glob('*', @params['a'] ? File::FNM_DOTMATCH : 0)
    file_paths.reverse! if @params['r']
    file_format =
      @params['l'] ? LongFormat.new(file_paths) : StandardFomat.new(file_paths, COLUMN_NUM)

    file_format.show_files
  end
end

ls = Ls.new(ARGV.getopts('alr'))
ls.run
