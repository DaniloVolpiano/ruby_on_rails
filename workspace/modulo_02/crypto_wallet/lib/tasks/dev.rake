namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_coins)
      %x(rails dev:add_mining_types)
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end
  
  
  desc "Cadastra as moedas"
  task add_coins: :environment do 
    show_spinner("Cadastrando moedas...") do
      coins = [
              { description: "Bitcoin",
              acronym: "BTC",
              url_image: "https://lh3.googleusercontent.com/proxy/SP3CYl0Ypat6TQV6NlLcXIElm668R8EHcwL4tyuJEV3k3SxpFi0OFL9EKSrRxIdtR2WrXT1MMe_P5evSjYEjYOAtBH9LRSaVrwiTO1iG06WXkFGrMxQ1Iu3E0-whe0M"
              },
              {
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://cdn4.iconfinder.com/data/icons/cryptocoins/227/ETH-512.png"    
              },
              {
              description: "Dash",
              acronym: "DASH",
              url_image: "https://media.dash.org/wp-content/uploads/dash-D-blue.png"  
              },
              {
              description: "Iota",
              acronym: "IOT",
              url_image: "https://img.icons8.com/ios/500/iota.png"  
              },
              {
              description: "ZCash",
              acronym: "ZEC",
              url_image: "https://z.cash/wp-content/uploads/2020/03/zcash-icon-fullcolor.png"  
              }
          ]
          
      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end
  
  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {name: "Proof of Work", acronym: "PoW"},
        {name: "Proof of Stake", acronym: "PoS"},
        {name: "Proof of Capacity", acronym: "PoC"}
      ]
      
      mining_types.each do |mining_type|
          MiningType.find_or_create_by!(mining_type)
        end
      end
    end
    
  private
  
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield 
    spinner.success("(#{msg_end})")
    
  end
end
