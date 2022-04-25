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
    file_paths =
      @params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    # data =
    #   @params['r'] ? StandardFomat.new(file_paths.reverse!, COLUMN_NUM) : StandardFomat.new(file_paths, COLUMN_NUM)
    # data = LongFormat.new(file_paths) if @params['l']

    file_paths = file_paths.reverse! if @params['r']
    file_format =
      @params['l'] ? LongFormat.new(file_paths) : StandardFomat.new(file_paths, COLUMN_NUM)

    file_format.sort
  end
end

ls = Ls.new(ARGV.getopts('alr'))
ls.run
