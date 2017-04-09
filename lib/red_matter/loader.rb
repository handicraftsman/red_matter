module RedMatter
  # Loader - processes Redfile / config block
  # @!attr [rw] verbose
  #   @return [Bool]
  class Loader
    attr_accessor :verbose

    def initialize
      @assets = {}
      @verbose = false
      @total = 0.0
    end

    # Loads given code from string (`dat` parameter) or yielded block
    # @param dat [String]
    # @param block [Proc]
    # @return [RedMatter::Loader] self
    def load(dat, &block)
      if block
        instance_exec(&block)
      else
        instance_eval(dat, nil, 'Redfile')
      end
      @assets.each_pair do |name, asset|
        t1 = Time.now.to_f
        asset.process
        t2 = Time.now.to_f
        took = t2 - t1
        @total += took
        puts "`#{name}`: #{took.truncate(6)} seconds" if @verbose
      end
      puts "Total: #{@total.truncate(6)} seconds" if @verbose
      self
    end

    # Adds asset node
    # @param name [String]
    # @param block [Proc]
    # @return [RedMatter::Loader] self
    def asset(name, &block)
      @assets[name] = RedMatter::Asset.new(&block)
      @assets[name].name = name
      self
    end
  end
end
