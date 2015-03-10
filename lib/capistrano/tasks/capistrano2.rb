Capistrano::Configuration.instance.load do

  _cset(:shoryuken_default_hooks) { true }

  _cset(:shoryuken_pid)      { File.join(shared_path, 'pids', 'shoryuken.pid') }
  _cset(:shoryuken_env)      { fetch(:rack_env, fetch(:rails_env, 'production')) }
  _cset(:shoryuken_log)      { File.join(shared_path, 'log', 'shoryuken.log') }
  _cset(:shoryuken_config)   { "#{current_path}/config/shoryuken.yml" }
  _cset(:shoryuken_requires) { [] }
  _cset(:shoryuken_queues)   { [] }
  _cset(:shoryuken_options)  { '--rails' }

  _cset(:shoryuken_cmd)     { "#{fetch(:bundle_cmd, 'bundle')} exec shoryuken" }

  _cset(:shoryuken_role)    { :app }

  if fetch(:shoryuken_default_hooks)
    after 'deploy:stop', 'shoryuken:stop'
    after 'deploy:start', 'shoryuken:start'
    before 'deploy:restart', 'shoryuken:restart'
  end

  namespace :shoryuken do
    desc 'Stop the shoryuken process, gracefully'
    task :stop, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      pid_file = fetch(:shoryuken_pid)
      
      run "cd #{current_path} ; kill -USR1 `cat '#{pid_file}'` >/dev/null 2>&1 || true"
      print 'Waiting for shoryuken to shutdown...'
      run "cd #{current_path} && while [ -f '#{pid_file}' ] && kill -0 `cat '#{pid_file}'` >/dev/null 2>&1; do sleep 1; done && rm -f '#{pid_file}'"
    end
  
    desc 'Shutdown the shoryuken process, immediately'
    task :shutdown, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      run "cd #{current_path} && [ -f '#{pid_file}' ] && kill `cat '#{pid_file}'`"
    end

    desc 'Start the shoryuken process'
    task :start, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      pid_file = fetch(:shoryuken_pid)
      
      args = ['--daemon']
      args.push "--pidfile '#{pid_file}'"
      logfile = fetch(:shoryuken_log) and args.push "--logfile '#{logfile}'"
      config = fetch(:shoryuken_config) and args.push "--config '#{config}'"
      queues = Array(fetch(:shoryuken_queues)) and queues.each{|queue| args.push "--queue #{queue}" }
      reqs = Array(fetch(:shoryuken_requires)) and reqs.each{|req| args.push "--require #{req}" }
      options = fetch(:shoryuken_options) and args.push Array(options).join(' ')
      
      cmd = fetch(:shoryuken_cmd)
      env = fetch(:shoryuken_env) and cmd = "RAILS_ENV=#{env} #{cmd}"
      
      run "cd #{current_path} && if [ -f '#{pid_file}' ] && kill -0 `cat '#{pid_file}'` >/dev/null 2>&1 ; then echo 'shoryuken is already running'; else #{cmd} #{args.compact.join(' ')} ; fi"
    end

    desc 'Restart shoryuken'
    task :restart, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      stop
      start
    end
    
    desc 'Make the shoryuken process log detailed status information'
    task :log_status, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      pid_file = fetch(:shoryuken_pid)
      
      run "cd #{current_path} && [ -f '#{pid_file}' ] && kill -TTIN `cat '#{pid_file}'`"
    end
    
    desc 'Tail the shoryuken log forever'
    task :tail_log, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      run "tail -f '#{fetch(:shoryuken_log)}'"
    end

    desc 'Tail ENV[number] lines of the shoryuken log'
    task :tail_log_lines, roles: lambda { fetch(:shoryuken_role) }, on_no_matching_servers: :continue do
      run "tail -n #{ENV.fetch('number',20)} '#{fetch(:shoryuken_log)}'"
    end
  end
end
