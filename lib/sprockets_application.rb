module SprocketsApplication
  class << self
    def routes(map)
      map.resource(:sprockets)
    end
    
    def source
      output_file.to_s
    end
    
    def install_script
      output_file.save_to(asset_path)
    end
    
    def install_assets
      secretary.install_assets
    end

    protected
      def secretary
        @secretary ||= Sprockets::Secretary.new(configuration.merge(:root => RAILS_ROOT))
      end
    
      def configuration
        YAML.load(IO.read(File.join(RAILS_ROOT, "config", "sprockets.yml"))) || {}
      end

      def output_file
        secretary.reset! unless source_is_unchanged?
        secretary.output_file
      end

      def asset_path
        File.join(Rails.public_path, "sprockets.js")
      end

      def source_is_unchanged?
        previous_source_last_modified, @source_last_modified = 
          @source_last_modified, secretary.source_last_modified
          
        previous_source_last_modified == @source_last_modified
      end
  end
end
