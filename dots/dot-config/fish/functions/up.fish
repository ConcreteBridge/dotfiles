function up --wraps='sudo xbps-install -Syu' --description 'alias up sudo xbps-install -Syu'
  sudo xbps-install -Syu $argv
        
end
