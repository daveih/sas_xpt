######################################################################################
# Xpt main
#-----------------------------------------------------
# Input: path to file to create
#        name of file to create
#        dataset label
#        metadata as hash
#        data as hash
#-----------------------------------------------------
# Output: See respective method
#-----------------------------------------------------
# Known limitations:
# - Read/Write: Make two xpt classes? Read and Write?
# - Write: Where to check whether a file exists before writing?
# - Write: Where to check lenght of filename? xpt format only allows 8 char in file
#          Or should we skip this check and truncate to 8 char in file?
#####################################################################################
require "xpt/read_data"
require "xpt/read_meta"
require "xpt/read_supp_meta"
require "xpt/create_data"
require "xpt/create_meta"

class Xpt
  attr_accessor :directory, :filename
  include Create_xpt_data_module
  include Create_xpt_metadata_module
  include Read_xpt_data_module
  include Read_xpt_metadata_module
  include Read_xpt_supp_metadata_module

  def initialize(inputDirectory, inputFilename)
    @directory = File.join(inputDirectory,"") # This makes sure that the directory always ends with "/"
    @filename = inputFilename+".xpt"
    return self
  end

  def read_data
    # Check if directory exist
    if !File.exist?(self.directory) then
      result = createError(-1,"(Xpt read_data) Input directory does not exist")
    # Check if file exist
    elsif !File.exist?(self.directory+self.filename) then
      result = createError(-2,"(Xpt read_data) Input file does not exist")
    # Read file
    else
      result = read_xpt_data(self.directory+self.filename)
    end
    return result
  end

  def read_meta
    # Check if directory exist
    if !File.exist?(self.directory) then
      result = createError(-1,"(Xpt read_meta) Input directory does not exist")

    # Check if file exist
    elsif !File.exist?(self.directory+self.filename) then
      result = createError(-2,"(Xpt read_meta) Input file does not exist")

    # Read file
    else
      result = read_xpt_metadata(self.directory+self.filename)
    end
    return result
  end

  def read_supp_meta
    # Check if directory exist
    if !File.exist?(self.directory) then
      result = createError(-1,"(Xpt read_supp_meta) Input directory does not exist")

    # Check if file exist
    elsif !File.exist?(self.directory+self.filename) then
      result = createError(-2,"(Xpt read_supp_meta) Input file does not exist")

    # Check if it is named as a SUPPxx dataset as well
    elsif self.filename !~ /^supp..\.xpt$/
      result = createError(-3,"(Xpt read_supp_meta) Incorrect naming of SUPP-- file")

    # Read file
    else
      result = read_xpt_supp_metadata(self.directory+self.filename)
    end
    return result
  end

  def create_meta(datasetLabel,metadata, overwrite = false, submissionConstraint = false)
    if submissionConstraint && !submissionFilenameOK? then
        return createError(-101,"(Xpt create_meta) Output filename longer than 8 characters")
    end
    if overwrite then
      return create_xpt_metadata(self.directory,self.filename,datasetLabel,metadata)
    else
      if !directoryExist? then
        return createError(-1,"(Xpt create_meta) Output directory does not exist")

      # Check if file exist
      elsif fileExist? then
        return createError(-2,"(Xpt create_meta) Output file already exists")

      # Create file
      else
        return create_xpt_metadata(self.directory,self.filename,datasetLabel,metadata)
      end
    end
  end

  def create_data(datasetLabel,metadata,realdata, overwrite = false, submissionConstraint = false)
    if submissionConstraint && !submissionFilenameOK? then
        return createError(-101,"(Xpt create_data) Output filename longer than 8 characters")
    end
    if overwrite then
      return create_xpt_data(self.directory,self.filename,datasetLabel,metadata,realdata)
    else
      if !directoryExist? then
        return createError(-1,"(Xpt create_data) Output directory does not exist")

      # Check if file exist
      elsif fileExist? then
        return createError(-2,"(Xpt create_data) Output file already exists")
      # Create file
      else
        return create_xpt_data(self.directory,self.filename,datasetLabel,metadata,realdata)
      end
    end
  end

  private

  def directoryExist?
    return File.exist?(self.directory)
  end
  def fileExist?
    return File.exist?(self.directory+self.filename)
  end
  def submissionFilenameOK?
    return self.filename.chomp(".xpt").length < 9
  end

  def createError(errorNo, errorText)
    result = {}
    result[:status] = errorNo
    result[:error] = errorText
    return result
  end
end

