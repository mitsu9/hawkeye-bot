module Hawkeye
  module Helper
    class GithubHelper
      class << self
        TREND_LANG  = %w(c go java php python scala ruby elixir haskell swift)
        TREND_SINCE = %w(daily weekly monthly)
        TREND_COUNT = 10

        def trending(lang, since)
          get_trends(lang, since)
        end

        def trending_url(lang, since)
          "https://github.com/trending/#{trending_param(lang, since)}"
        end

        private

        def get_trends(lang, since)
          doc = get_trend_html(lang, since)
          repo_list = doc.xpath('//div[@class="explore-content"]/ol[@class="repo-list"]/li')
          repo_list.take(TREND_COUNT).map do |node|
            repo_href = node.xpath('.//a')[0]["href"]
            summary = node.xpath('.//div[@class="py-1"]/p').text.strip
            { repo: repo_href, summary: summary , link: "https://github/com#{repo_href}" }
          end
        end

        def get_trend_html(lang, since)
          response = trend_client.get do |req|
            req.url trending_param(lang, since)
          end
          charset = "utf-8"
          Nokogiri::HTML.parse(response.body, nil, charset)
        end

        def trending_param(lang, since)
          url_param = ""
          url_param += lang if TREND_LANG.include?(lang)
          url_param += "?since=#{since}" if TREND_SINCE.include?(since)
          url_param
        end

        def trend_client()
          url = "https://github.com/trending/"
          client = Faraday.new(:url => url) do |builder|
            builder.request  :url_encoded
            builder.response :logger
            builder.adapter  :net_http
          end
          client
        end
      end
    end
  end
end