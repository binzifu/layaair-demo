import { Laya } from "Laya";
import { Camera } from "laya/d3/core/Camera";
import { Scene3D } from "laya/d3/core/scene/Scene3D";
import { Vector3 } from "laya/d3/math/Vector3";
import { Vector4 } from "laya/d3/math/Vector4";
import { Stage } from "laya/display/Stage";
import { Button } from "laya/ui/Button";
import { Handler } from "laya/utils/Handler";
import { Stat } from "laya/utils/Stat";
import { Laya3D } from "Laya3D";
import { Browser } from "laya/utils/Browser"
import { BitmapFont } from "laya/display/BitmapFont";
import { Text } from "laya/display/Text";



export class SceneLoad1 {
	private fontName: string = "fontClip"
	constructor() {
		//初始化引擎
		Laya3D.init(0, 0);
		Stat.show();
		Laya.stage.scaleMode = Stage.SCALE_FULL;
		Laya.stage.screenMode = Stage.SCREEN_NONE;
		this.loadFont();

		//加载场景
		Scene3D.load("res/threeDimen/LayaScene_MaskModelTest/Conventional/MaskModelTest.ls", Handler.create(this, function (scene: Scene3D): void {
			(<Scene3D>Laya.stage.addChild(scene));
			//获取场景中的相机
			var camera: Camera = (<Camera>scene.getChildByName("Camera"));
		}));
	}


	private loadFont(): void {
		var bitmapFont: BitmapFont = new BitmapFont();

		bitmapFont.loadFont("res/fontTest/fontClip.fnt", new Handler(this, this.onFontLoaded, [bitmapFont]));
	}
	private onFontLoaded(bitmapFont: BitmapFont): void {
		bitmapFont.setSpaceWidth(10);
		Text.registerBitmapFont(this.fontName, bitmapFont);
		//this.createText(txt="上半身",250,true,font,leading=5,zOrder=999999999,pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1),   this.fontName);

		this.createText(this.fontName);
		this.createText1(this.fontName);
		this.createText2(this.fontName);
	}
	private createText(font: string): void {
		var txt: Text = new Text();
		txt.width = 250;
		txt.wordWrap = true;
		txt.text = "上半身";
		txt.font = font;
		txt.leading = 5;
		//txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
		txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);

		Laya.stage.addChild(txt);
	}
	createText1(font) {
		var txt = new Text();
		txt.width = 250;
		txt.wordWrap = true;
		txt.text = "正常";
		txt.font = font;
		txt.leading = 5;
		txt.zOrder = 999999999;
		//txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
		txt.pos(700, 450);
		Laya.stage.addChild(txt);
	} createText2(font) {
		var txt = new Text();
		txt.width = 250;
		txt.wordWrap = true;
		txt.text = "上半身";
		txt.font = font;
		txt.leading = 5;
		txt.zOrder = 999999999;
		txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
		txt.pos(900, 450);
		Laya.stage.addChild(txt);
	}


}



