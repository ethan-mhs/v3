class ProductView {
  int count;
  int id;
  String name;
  int qty;
  String sku;
  String url;
  double originalPrice;
  double promotePrice;
  int promotePercent;

  ProductView(
      {this.count,
        this.id,
        this.name,
        this.qty,
        this.sku,
        this.url,
        this.originalPrice,
        this.promotePrice,
        this.promotePercent});

  ProductView.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = json['id'];
    name = json['name'];
    qty = json['qty'];
    sku = json['sku'];
    url = json['url'];
    originalPrice = json['originalPrice'];
    promotePrice = json['promotePrice'];
    promotePercent = json['promotePercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['id'] = this.id;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['sku'] = this.sku;
    data['url'] = this.url;
    data['originalPrice'] = this.originalPrice;
    data['promotePrice'] = this.promotePrice;
    data['promotePercent'] = this.promotePercent;
    return data;
  }
}