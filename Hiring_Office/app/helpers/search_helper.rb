module SearchHelper
  def show_price_per_day_month price, price_type_index
    if price_type_index % 2 != 0
      content_tag :span, class: "label label-success price-tag" do
        number_with_precision(price.price, precision: Settings.precision_number) +
          t(".usd_slash") + (price.booking_type.name.humanize)
      end
    end
  end

  def show_price_per_day price, index
    if index == Settings.price_per_day
      content_tag :span, class: "label label-success price-tag" do
        number_with_precision(price.price, precision: Settings.precision_number) +
          t("usd_slash") + (price.booking_type.name.humanize)
      end
    end
  end

  def check_avg object 
    if object.average(Settings.rate).nil?
      return Settings.default_rating_avg
    else
      object.average(Settings.rate).avg
    end
  end
end
