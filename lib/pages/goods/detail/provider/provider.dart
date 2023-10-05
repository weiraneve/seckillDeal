import 'package:flutter/cupertino.dart';
import 'package:seckill_deal/common/auth/state.dart';
import 'package:seckill_deal/network/goods/detail/model/goods_detail.dart';
import 'package:seckill_deal/network/goods/list/model/goods.dart';
import 'package:seckill_deal/network/result.dart';
import 'package:seckill_deal/pages/goods/detail/repository/repository.dart';
import 'package:seckill_deal/res/strings.dart';

class GoodsDetailProvider extends ChangeNotifier {
  int? stockCount;
  Goods? goods;
  final int goodsId;
  final GoodsDetailRepository _repository;

  AuthState _state = const AuthInitial();

  AuthState get state => _state;

  GoodsDetailProvider(this.goodsId, {GoodsDetailRepository? repository})
      : _repository = repository ?? GoodsDetailRepository() {
    _getDetail(goodsId);
  }

  Future<void> _getDetail(int goodsId) async {
    Result<GoodsDetail> goodsDetail = await _repository.getDetail(goodsId);
    stockCount = goodsDetail.data.stockCount;
    goods = goodsDetail.data.goods;
    notifyListeners();
  }

  Future<void> seckill(int goodsId) async {
    _updateState(AuthLoading());
    String seckillResult = await _repository.seckill(goodsId);
    if (seckillResult == GoodsDetailRepository.success) {
      _updateState(AuthSuccess(stringRes(R.successful)));
    } else {
      _updateState(AuthFailure(error: seckillResult));
    }
  }

  void _updateState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
