function lt --wraps='eza -F1 --sort new' --wraps='eza -F 1 --sort new' --wraps='eza -F -1 --sort new' --description 'alias lt eza -F -1 --sort new'
  eza -F -1 --sort new $argv
        
end
