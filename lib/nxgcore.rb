require 'fileutils'
require 'nxghtml.rb'

class NxgCore
    class NxgReport

      include NxgHTML

        def initialize(data_provider)
          @data_provider = data_provider
          @data_provider[:pass] = 0
          @data_provider[:fail] = 0
          @data_provider[:total] = 0
        end

        def setup(location: "./NxgReport.html", title: "$NxgReport")
            @data_provider[:report_path] = location.empty? ? "./NxgReport.html" : location
            folder_check()
            @data_provider[:title] = title
            @data_provider[:open_on_completion] = false
            @data_provider[:features] = Array.new()
            @start_time = Time.now.to_f
        end
    
        def open_upon_execution(value: true)
          return if !value

          @data_provider[:open_on_completion] = value
        end
    
        def set_environment(name: "")
          return if name.empty?() 
          
          @data_provider[:environment] = name
        end
    
        def set_app_version(no: "")
          return if no.empty?()
            
          version_no = no.downcase.gsub("app", "").gsub("version", "").strip
          @data_provider[:app_version] = "App Version #{version_no}"
        end
    
        def set_release(name: "")
          return if name.empty?() 
            
          @data_provider[:release_name] = name
        end
    
        def set_os(name: "")
          return if name.empty?() 
            
          @data_provider[:os] = name
        end
    
        def set_device(name: "")
          return if name.empty?() 
            
          @data_provider[:device] = name
        end
    
        def set_execution(date: "")
          return if date.empty?() 
            
          @data_provider[:execution_date] = date
        end

        def set_execution_time(time)
          time_diff_in_mins = 0
          if time == 0
            @end_time = Time.now.to_f
            time_diff_in_mins = ((@end_time - @start_time)  / 60).to_i
          else
            time_diff_in_mins = (time / 60).to_i
          end

          if time_diff_in_mins >= 60
            time_diff_in_hrs = (time_diff_in_mins / 60.to_f).round(2)
            @data_provider[:execution_time] = "#{time_diff_in_hrs} #{time_diff_in_hrs == 1 ? "hour" : "hours"}"
          else
            @data_provider[:execution_time] = "#{time_diff_in_mins} mins"
          end
        end
    
        def log_test(feature_name: "", test_name:"", test_status: "", comments: "")
          if feature_name.nil?() || feature_name.strip.empty?()
            log("Feature name cannot be empty.")
            return
          end
  
          if test_status.nil?() || test_status.strip.empty?()
            log("Test status cannot be empty.")
            return
          end

          if test_name.nil?() || test_name.strip.empty?()
            log("Test name cannot be empty.")
            return
          end

          f_name = feature_name.strip
          t_name = test_name.strip
          t_pass = test_status.strip.downcase.include?('pass') ? true : false
          t_comments = comments.strip

          if !feature_exists?(f_name)
            new_feature = {
              "name" => f_name,
              "total" => 0,
              "pass" => 0,
              "fail" => 0,
              "tests" => Array.new()
            }
            @data_provider[:features].push(new_feature)
          end

          update_feature(f_name, t_name, t_pass, t_comments)
          @data_provider[:total] += 1
          @data_provider[t_pass ? :pass : :fail] += 1
        end
    
        def build(execution_time: 0)
          set_execution_time(execution_time)
          write()
          if @data_provider[:open_on_completion]
            system("open #{@data_provider[:report_path]}") if File.file?(@data_provider[:report_path])
          end
        end
    
        # Private methods

        def update_feature(f_name, t_name, t_pass, t_comments)
          @data_provider[:features].each do |feature|
            if feature["name"].eql?(f_name)
              feature["total"]+=1
              feature[t_pass ? "pass" : "fail"]+=1
              feature["tests"].push({
                "name" => t_name,
                "testPass" => t_pass,
                "comments" => t_comments
              })
              return
            end
          end
        end

        def feature_exists?(feature_name)
          @data_provider[:features].each do |feature|
            return true if feature["name"].eql?(feature_name)
          end
          return false
        end

        def log(message)
          puts("🤖- #{message}")
        end
    
        def folder_check()
          folder = File.dirname(@data_provider[:report_path])
          FileUtils.mkdir_p(folder) unless File.directory?(folder)
        end
    
        def clean()
            File.delete(@data_provider[:report_path]) if File.file?(@data_provider[:report_path])
        end
    
        def write()
          clean()
          if @data_provider[:features].length == 0
            log("No tests logged, cannot build empty report.")
            return
          end
          template = File.new(@data_provider[:report_path], 'w')
          template.puts(html(@data_provider))
          template.close()
        end

        private :log, :clean, :write, :update_feature, :folder_check
    end

    private_constant :NxgReport

    def instance(data_provider: Hash.new())
        NxgReport.new(data_provider)
    end
end