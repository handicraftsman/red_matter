module RedMatter
  # Asset node. Has multiple input files and one output file.
  # @!attr [r] infiles
  #   @return [Array<String,Hash>] All input files
  # @!attr [r] outfile
  #   @return [String] Output file
  # @!attr [rw] name
  #   @return [String] Asset's name
  class Asset
    attr_reader :infiles, :outfile
    attr_accessor :name

    def initialize(&block)
      @name    = ''
      @infiles = []
      @outfile = nil
      instance_exec(&block)
    end

    # Adds input file(s) to asset
    # @param input [String,Array]
    # @param block [Proc] If it is given, will be executed to get processed file content
    # @return [RedMatter::Asset] self
    def input(input, &block)
      if input.instance_of? String
        if block
          @infiles << {
            enable_cache: input
            block: block
          }
        else
          @infiles << File.expand_path(input)
        end
      elsif input.instance_of? Array
        input.each do |file|
          if block
            @infiles << {
              file:  File.expand_path(file),
              block: block
            }
          else
            @infiles << File.expand_path(file)
          end
        end
      else
        fail TypeError, "Input #{f.inspect} is not a string nor an array!"
      end
      self
    end

    # Sets output file of current asset
    # @param file [String]
    # @param block [Proc] If given, packed result will be post-processed. 
    # @return [RedMatter::Asset] self
    def output(file, &block)
      @outfile = File.expand_path(file)
      @block   = block
      self
    end

    # Processes all input files and writes result to output file (if any)
    # @return [String] output
    def process
      outs = []
      @infiles.each do |f|
        if f.instance_of? Hash
          dat = f[:block].(f[:file])
          if dat.instance_of? String
            out << dat + "\n\n"
          else
            fail TypeError, "#{dat.class} returned, String expected"
          end
        elsif f.instance_of? String
          outs << File.read(f)
        elsif f.instance_of? Array
          outs << f.map { |fn| File.read(fn) }
        else
          fail TypeError, "Infile #{f.inspect} is not a hash nor a string nor an array!"
        end
      end
      out = outs.join("\n\n")
      if @block
        out = @block.(out)
      end
      if @outfile
        File.delete(@outfile) if File.exist? @outfile
        File.open(@outfile, 'w') do |f|
          f.write(out)
        end
      end
      out
    end
  end
end