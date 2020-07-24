namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
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
              url_image: "https://bitcoin.org/img/icons/opengraph.png?1594728624",
              mining_type: MiningType.find_by(acronym: 'PoW')
              },
              {
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://cdn4.iconfinder.com/data/icons/cryptocoins/227/ETH-512.png",
              mining_type: MiningType.all.sample
              },
              {
              description: "Dash",
              acronym: "DASH",
              url_image: "https://media.dash.org/wp-content/uploads/dash-D-blue.png",
              mining_type: MiningType.all.sample
              },
              {
              description: "Iota",
              acronym: "IOT",
              url_image: "https://img.icons8.com/ios/500/iota.png",  
              mining_type: MiningType.all.sample
              },
              {
              description: "ZCash",
              acronym: "ZEC",
              url_image: "https://z.cash/wp-content/uploads/2020/03/zcash-icon-fullcolor.png",  
              mining_type: MiningType.all.sample
              },
              {
              description: "Litecoin",
              acronym: "LTC",
              url_image: "https://janusinvestimentos.com/wp-content/uploads/2018/03/LTC-400.png",  
              mining_type: MiningType.all.sample
              },
              {
              description: "Ripple",
              acronym: "XRP",
              url_image: "https://www.comocomprarcriptomoedas.com/wp-content/uploads/2018/04/ripple-logo-xrp.png",  
              mining_type: MiningType.all.sample
              },
              {
              description: "Stellar Lumen",
              acronym: "ZEC",
              url_image: "https://www.hashinvest.com.br/wp-content/uploads/2018/08/fcc70c_1040d226edf044ccbca11aa950ecadd8_mv2.png",  
              mining_type: MiningType.all.sample
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
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
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
