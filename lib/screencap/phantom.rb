require 'cgi'

module Screencap
  class Phantom
    RASTERIZE = SCREENCAP_ROOT.join('screencap', 'raster.js')

    def self.rasterize(url, path, args = {})
      cloned_args = args.clone
      phantom_params = get_phantom_params args.clone
      params = {
        url: CGI::escape(url),
        output: path
      }.merge(cloned_args).collect {|k,v| "#{k}=#{v}"}
      puts RASTERIZE.to_s, params if(args[:debug])
      result = Phantomjs.run(phantom_params, RASTERIZE.to_s, *params)
      puts result if(args[:debug])
      raise Screencap::Error, "Could not load URL #{url}" if result.match /Unable to load/

    end

    def self.get_phantom_params(args)
      opts = args[:phantomjs] || {}
      args.delete(:phantomjs)
      opts.collect {|k,v| "#{k}=#{v}"}.join(' ')
    end

    def quoted_args(args)
      args.map{|x| quoted_arg(x)}
    end

    def quoted_arg(arg)
      return arg if arg.starts_with?("'") && arg.ends_with?("'")
      arg = "'" + arg unless arg.starts_with?("'")
      arg = arg + "'" unless arg.ends_with?("'")
      arg
    end
  end
end
