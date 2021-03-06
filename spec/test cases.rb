###################################################
# Test for reading data
###################################################
inputDirectory="../spec/support/xpt_files"
theDomain="dm"
xpt = Xpt.new(inputDirectory,theDomain)
xpt_data = xpt.read_data

outputDirectory="../spec/support/output"
outputFileName = outputDirectory+theDomain+"_xpt_data.tsv"
outputFile = File.new(outputFileName,"w")

xpt_data[:variables].each do |item|
    item.each do |map|
        outputFile.write map[:name].to_s+"\t"
    end
end

outputFile.write "\n"

xpt_data[:data].each do |list|
    list.each do |map|
        map.each do |k, v|
            outputFile.write v.to_s+"\t"
        end
        outputFile.write "\n"
    end
end

puts "Test data created: "+outputFileName


###################################################
# Test for reading metadata only
###################################################
inputDirectory="../spec/support/xpt_files"
theDomain="dm"
xpt = Xpt.new(inputDirectory,theDomain)
xpt_meta = xpt.read_meta

outputDirectory="../spec/support/output"
outputFileName = outputDirectory+theDomain+"_xpt_meta.tsv"
outputFile = File.new(outputFileName,"w")
xpt_meta[:variables].each do |item|
    item.each do |map|
        outputFile.write map[:name].to_s+"\t"
    end
end
outputFile.write "\n"

puts "created test output in file:"+outputFileName

###################################################
# Test for reading supp metadata only
###################################################
inputDirectory="../spec/support/xpt_files"
theDomain="suppdm"
xpt = Xpt.new(inputDirectory,theDomain)
xpt_supp_meta = xpt.read_supp_meta

if (xpt_supp_meta.instance_of? Hash) then
outputDirectory="../spec/support/output"
  outputFileName = outputDirectory+theDomain+"_xpt_supp_meta.tsv"
  outputFile = File.new(outputFileName,"w")
  xpt_supp_meta[:variables].each do |item|
      outputFile.write item[:name]
      # item.each do |map|
      #     outputFile.write map[:name].to_s+"\t"
      # end
  end
  outputFile.write "\n"

  puts "created test output in file:"+outputFileName
end


###################################################
# Test for creating metadata only
###################################################
puts "Creating metadata only"
metadata = [{name:"var1",label:"Label var1",type:"char",length:11},
            {name:"var2",label:"Label var2",type:"num",length:8}
]

outputDirectory="../output"
filename="testmeta"
puts "Set output directory and filename: "+outputDirectory+"-"+filename

xpt = Xpt.new(outputDirectory,filename)

#cres = xpt.create_meta("dataset label",metadata)  # Check if file exist
cres = xpt.create_meta("dataset label",metadata, true) # Overwrite
#cres = xpt.create_meta("dataset label",metadata, true, true) # Check submission readiness

puts "Created file: "+outputDirectory+" - "+filename+".xpt"
puts "cres="+cres.to_s


###################################################
# Test for creating real data
###################################################
puts "Creating data"
metadata = [{name:"c1",label:"lc 1",type:"char",length:11},
            {name:"n1",label:"ln 1",type:"num",length:8}
]
rows = [["xpt.rb!",1.1],
        ["Anything",-0.1],
        ["character",4503599627370495]
    ]

outputDirectory="../output"
filename="testdata"
puts "Set output directory and filename: "+outputDirectory+"-"+filename

xpt = Xpt.new(outputDirectory,filename)
cres = xpt.create_data("dataset label",metadata,rows)

if cres[:status] == 1 then
  puts "Created file: "+outputDirectory+" - "+filename+".xpt"
else
  puts "error: "+cres[:error].to_s
end
