import 'package:flutter_control/core.dart';

import 'cards_controller.dart';

class CardsPage extends SingleControlWidget<CardsController> with RouteControl {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize('title')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FieldBuilder<String>(
              controller: controller.countLabel,
              builder: (context, value) => Center(child: Text(value)),
            ),
          ),
        ],
      ),
      body: ListBuilder<CardModel>(
        controller: controller.cards,
        builder: (context, items) {
          return ListView.builder(
            itemCount: controller.cards.length,
            itemBuilder: (context, index) => CardWidget(controller.cards[index]),
          );
        },
        noData: (context) => Center(
              child: Text(localize('empty_list')),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addCard,
        child: Icon(Icons.add),
      ),
    );
  }
}

class CardWidget extends BaseControlWidget {
  final CardModel item;

  CardWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: Offset(2.0, 2.0), blurRadius: 6.0, color: Colors.black45),
        ],
      ),
      child: FlatButton(
        padding: const EdgeInsets.all(16.0),
        onPressed: () => ControlProvider.of<CardsController>()?.openCard(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.title,
              style: theme.textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FieldBuilder<String>(
                controller: item.countLabel,
                builder: (context, label) => Text(label),
              ),
            ),
            FieldBuilder<double>(
              controller: item.progress,
              builder: (context, progress) => LinearProgressIndicator(value: progress),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends SingleControlWidget<DetailController> with RouteControl {
  static PageRouteProvider route() => PageRouteProvider.of(
        identifier: 'card_detail',
        builder: (context) => DetailPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FieldBuilder<String>(
          controller: controller.title,
          builder: (context, title) => Text(title),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: controller.deleteSelf,
          ),
        ],
      ),
      body: ListBuilder<CardItemModel>(
        controller: controller.items,
        builder: (context, items) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ItemWidget(items[index]),
          );
        },
        noData: (context) => Center(
              child: Text(localize('empty_list')),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemWidget extends BaseControlWidget {
  final CardItemModel item;

  ItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: item.toggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FieldBuilder<bool>(
            controller: item.done,
            builder: (context, done) => Checkbox(value: done, onChanged: item.changeState),
          ),
          Text(item.title),
        ],
      ),
    );
  }
}
