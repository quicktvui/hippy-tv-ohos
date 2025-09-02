import {HippyMap} from 'hippy'
import { LayoutAttach } from '../components/fastlist/LayoutAttach';

export class ViewUtils{
  static getTextGravity(gs : string) : TextAlign{
    switch (gs){
      case  'center':
        return TextAlign.Center;
      case 'top':
      case 'bottom':
      case 'centerHorizontal':
      case 'centerVertical':
        return TextAlign.JUSTIFY
      case 'end':
        return TextAlign.End;
      default :
        return TextAlign.Start
    }
  }

  static applyStyleNode(style: HippyMap,attach : LayoutAttach): void {
    if (style == null || attach == null) {
      return;
    }
    attach.setStyles(style)
    //暂时写死LTR
    //c.setDirection(o.getDirection());

    // c.setFlexDirection(o.getFlexDirection());
    // c.setJustifyContent(o.getJustifyContent());
    // c.setAlignContent(o.getAlignContent());
    // c.setAlignItems(o.getAlignItems());
    // c.setAlignSelf(o.getAlignSelf());
    // c.setPositionType(o.getPositionType());
    //
    // if (o.getPosition(FlexSpacing.TOP) != 0) {
    //   c.setPosition(FlexSpacing.TOP, o.getPosition(FlexSpacing.TOP));
    // }
    // if (o.getPosition(FlexSpacing.LEFT) != 0) {
    //   c.setPosition(FlexSpacing.LEFT, o.getPosition(FlexSpacing.LEFT));
    // }
    // if (o.getPosition(FlexSpacing.RIGHT) != 0) {
    //   c.setPosition(FlexSpacing.RIGHT, o.getPosition(FlexSpacing.RIGHT));
    // }
    // if (o.getPosition(FlexSpacing.BOTTOM) != 0) {
    //   c.setPosition(FlexSpacing.BOTTOM, o.getPosition(FlexSpacing.BOTTOM));
    // }
    //
    // c.setWrap(o.Style().getWrap());
    // c.setOverflow(o.getOverflow());
    // c.setFlexGrow(o.getFlexGrow());
    // c.setFlexShrink(o.getFlexShrink());
    // c.setFlexBasis(o.getFlexBasis());
    //
    // if (o.getStyleWidth() > 0) {
    //   c.setStyleWidth(o.getStyleWidth());
    // }
    // if (o.getStyleHeight() > 0) {
    //   c.setStyleHeight(o.getStyleHeight());
    // }
    //
    // for (let i = 0; i < 4; i++) {
    //   c.setMargin(i, o.getMargin(i));
    //   c.setPadding(i, o.getPadding(i));
    //   c.setBorder(i, o.getBorder(i));
    // }
  }
}
