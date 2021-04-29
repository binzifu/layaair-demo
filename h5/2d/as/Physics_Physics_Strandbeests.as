package {
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.physics.BoxCollider;
	import laya.physics.ChainCollider;
	import laya.physics.CircleCollider;
	import laya.physics.joint.DistanceJoint;
	import laya.physics.joint.RevoluteJoint;
	import laya.physics.Physics;
	import laya.physics.PhysicsDebugDraw;
	import laya.physics.PolygonCollider;
	import laya.physics.RigidBody;
	import laya.ui.Label;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class Physics_Physics_Strandbeests {
		private var scale = 2.5;
		private var pos: Array = [500, 400];
		private var m_offset: Array = [0, -80 * this.scale];
		private var pivot: Array = [0, 8 * this.scale];
		private var wheel: Sprite;
		private var chassis: Sprite;
		private var motorJoint: RevoluteJoint;
		private var label: Label;
		public function Physics_Strandbeests() {
			Laya.Config.isAntialias = true;
			Laya.init(1200, 700, WebGL);
			Stat.show();
			Physics.enable();
			PhysicsDebugDraw.enable();
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.scaleMode = Stage.SCALE_FIXED_AUTO;
			Laya.stage.bgColor = "#232628";

			this.construct();
            this.eventListener();
		}
		private function construct() {
			// Ground
			var ground = new Sprite();
			Laya.stage.addChild(ground);
			var rigidbody: RigidBody = new RigidBody();
			rigidbody.type = "static";
			ground.addComponentIntance(rigidbody);
			var chainCollider: ChainCollider = ground.addComponent(ChainCollider);
			chainCollider.points = "50,200,50,570,1050,570,1050,200";

			// Balls
			for (var i = 1; i <= 32; i++) {
				var small = new Sprite();
				small.pos(i * 30 + 50, 570 - 5 * this.scale);
				Laya.stage.addChild(small);
				var sBody: RigidBody = small.addComponent(RigidBody);
				var sCollider: CircleCollider = small.addComponent(CircleCollider);
				sCollider.radius = 2.5 * this.scale;
			}

			// Chassis
			var chassis: Sprite = this.chassis = new Sprite();
			chassis.pos(this.pos[0] + this.pivot[0] + this.m_offset[0], this.pos[1] + this.pivot[1] + this.m_offset[1]).size(50 * this.scale, 20 * this.scale);
			Laya.stage.addChild(chassis);
			var chassisBody: RigidBody = chassis.addComponent(RigidBody);
			chassisBody.group = -1;
			var chassisCollider: BoxCollider = chassis.addComponent(BoxCollider);
			chassisCollider.density = 1;
			chassisCollider.width = 50 * this.scale;
			chassisCollider.height = 20 * this.scale;
			chassisCollider.x = -25 * this.scale;
			chassisCollider.y = -10 * this.scale;

			// Circle
			var wheel = this.wheel = new Sprite();
			wheel.pos(this.pos[0] + this.pivot[0] + this.m_offset[0], this.pos[1] + this.pivot[1] + this.m_offset[1]); //.size(32, 32);
			Laya.stage.addChild(wheel);
			var wheelBody: RigidBody = wheel.addComponent(RigidBody);
			wheelBody.group = -1;
			var wheelCollider: CircleCollider = wheel.addComponent(CircleCollider);
			wheelCollider.density = 1;
			wheelCollider.radius = 16 * this.scale;
			wheelCollider.x = -16 * this.scale;
			wheelCollider.y = -16 * this.scale;

			// 转动关节
			var motorJoint: RevoluteJoint = this.motorJoint = new RevoluteJoint();
			motorJoint.otherBody = wheelBody;
			// motorJoint.anchor = this.pivot;
			motorJoint.motorSpeed = 2.0;
			motorJoint.maxMotorTorque = 400.0;
			motorJoint.enableMotor = true;
			chassis.addComponentIntance(motorJoint);

			var wheelOriBody = wheelBody.getBody();
			var wheelAnchor = [this.pivot[0], this.pivot[1] - 8 * this.scale];
			this.createLeg(-1, wheelAnchor);
			this.createLeg(1, wheelAnchor);
			wheelOriBody.SetTransform(wheelOriBody.GetPosition(), 120.0 * Math.PI / 180.0);
			this.createLeg(-1.0, wheelAnchor);
			this.createLeg(1.0, wheelAnchor);
			wheelOriBody.SetTransform(wheelOriBody.GetPosition(), -120.0 * Math.PI / 180.0);
			this.createLeg(-1.0, wheelAnchor);
			this.createLeg(1.0, wheelAnchor);
        }

		private function createLeg(s: Number, wheelAnchor) {
			const box2d: any = window.box2d;
			const wheelBody: RigidBody = this.wheel.getComponent(RigidBody);
			const chassisBody: RigidBody = this.chassis.getComponent(RigidBody);

			const p1 = [54 * s * this.scale, -61 * -1 * this.scale];
			const p2 = [72 * s * this.scale, -12 * -1 * this.scale];
			const p3 = [43 * s * this.scale, -19 * -1 * this.scale];
			const p4 = [31 * s * this.scale,  8  * -1 * this.scale];
			const p5 = [60 * s * this.scale,  15 * -1 * this.scale];
			const p6 = [25 * s * this.scale,  37 * -1 * this.scale];

			var leg1 = new Sprite();
			leg1.pos(this.pos[0] + this.m_offset[0], this.pos[1] + this.m_offset[1] + 16 * this.scale); // TODO 这里的数值待优化
			Laya.stage.addChild(leg1);
			var legBody1: RigidBody = leg1.addComponent(RigidBody);
			legBody1.angularDamping = 10;
			legBody1.group = -1;
			var legCollider1: PolygonCollider = leg1.addComponent(PolygonCollider);
			legCollider1.density = 1;
			var leg2 = new Sprite();
			leg2.pos(this.pos[0] + this.m_offset[0] + p4[0], this.pos[1] + this.m_offset[1] + p4[1] + 16 * this.scale);
			Laya.stage.addChild(leg2);
			var legBody2: RigidBody = leg2.addComponent(RigidBody);
			legBody2.angularDamping = 10;
			legBody2.group = -1;
			var legCollider2: PolygonCollider = leg2.addComponent(PolygonCollider);
			legCollider2.density = 1;

			if (s > 0) {
				legCollider1.points = p1.concat(p2).concat(p3).join(",");
				legCollider2.points = [0, 0].concat(B2Math.SubVV(p5, p4)).concat(B2Math.SubVV(p6, p4)).join(",");
			} else {
				legCollider1.points = p1.concat(p3).concat(p2).join(",");
				legCollider2.points = [0, 0].concat(B2Math.SubVV(p6, p4)).concat(B2Math.SubVV(p5, p4)).join(",");
			}
			
			const dampingRatio: number = 0.5;
			const frequencyHz: number = 10.0;
			var distanceJoint1: DistanceJoint = new DistanceJoint();
			distanceJoint1.otherBody = legBody2;
			distanceJoint1.selfAnchor = p2;
			distanceJoint1.otherAnchor = B2Math.SubVV(p5, p4);
			distanceJoint1.frequency = frequencyHz;
			distanceJoint1.damping = dampingRatio;
			leg1.addComponentIntance(distanceJoint1);

			var distanceJoint2: DistanceJoint = new DistanceJoint();
			distanceJoint2.otherBody = legBody2;
			distanceJoint2.selfAnchor = p3;
			// distanceJoint2.otherAnchor = p4;
			distanceJoint2.frequency = frequencyHz;
			distanceJoint2.damping = dampingRatio;
			leg1.addComponentIntance(distanceJoint2);

			var localAnchor = new box2d.b2Vec2();
			wheelBody.getBody().GetLocalPoint({x: (this.pos[0] + this.m_offset[0]) / Physics.PIXEL_RATIO, y: (this.pos[1] + this.m_offset[1]) / Physics.PIXEL_RATIO}, localAnchor);
			var anchor = [-localAnchor.x * Physics.PIXEL_RATIO, -localAnchor.y * Physics.PIXEL_RATIO];

			var distanceJoint3: DistanceJoint = new DistanceJoint();
			distanceJoint3.otherBody = wheelBody;
			distanceJoint3.selfAnchor = p3;
			distanceJoint3.otherAnchor = anchor; // 因为有旋转，localAnchor很难计算，使用绝对位置换算
			distanceJoint3.frequency = frequencyHz;
			distanceJoint3.damping = dampingRatio;
			leg1.addComponentIntance(distanceJoint3);

			var distanceJoint4: DistanceJoint = new DistanceJoint();
			distanceJoint4.otherBody = wheelBody;
			distanceJoint4.selfAnchor = B2Math.SubVV(p6, p4);
			distanceJoint4.otherAnchor = anchor;
			distanceJoint4.frequency = frequencyHz;
			distanceJoint4.damping = dampingRatio;
			leg2.addComponentIntance(distanceJoint4);

			var revoluteJoint: RevoluteJoint = new RevoluteJoint();
			revoluteJoint.otherBody = legBody2;
			revoluteJoint.anchor = B2Math.AddVV(p4, this.pivot);
			this.chassis.addComponentIntance(revoluteJoint);
		}

		private function eventListener() {
			// 双击屏幕，仿生机器人向相反方向运动
			Laya.stage.on(Event.DOUBLE_CLICK, this, () => {
				this.motorJoint.motorSpeed = -this.motorJoint.motorSpeed;
			});

			// 单击产生新的小球刚体
			Laya.stage.on(Event.CLICK, this, () => {
				const chassisBody = this.chassis.getComponent(RigidBody);
				const chassisPos = chassisBody.getBody().GetPosition();
				var newBall = new Sprite();
				Laya.stage.addChild(newBall);
				var circleBody: RigidBody = newBall.addComponent(RigidBody);
				var circleCollider: CircleCollider = newBall.addComponent(CircleCollider);
				circleCollider.radius = 3 * this.scale;
				circleCollider.x = Laya.stage.mouseX;
				circleCollider.y = Laya.stage.mouseY;
				var circlePosx = circleCollider.x / Physics.PIXEL_RATIO;
				var circlePosy = circleCollider.y / Physics.PIXEL_RATIO;
				var velocityX = chassisPos.x - circlePosx;
				var velocityY = chassisPos.y - circlePosy;
				circleBody.linearVelocity = {x: velocityX * 5, y: velocityY * 5};
				Laya.timer.frameOnce(120, this, function() {
					newBall.destroy();
				});
			});

			var label: Label = this.label = Laya.stage.addChild(new Label("双击屏幕，仿生机器人向相反方向运动\n单击产生新的小球刚体")) as Label;
			label.top = 20;
			label.right = 20;
			label.fontSize = 16;
			label.color = "#e69999";
		}

		private function dispose() {
			Laya.stage.offAll(Event.CLICK);
			Laya.stage.offAll(Event.DOUBLE_CLICK);
			Laya.stage.removeChild(this.label);
		}
    }
}

class B2Math {
    public static function AddVV(a, b) {
        return [a[0] + b[0], a[1] + b[1]];
    }

    public static function SubVV(a, b) {
        return [a[0] - b[0], a[1] - b[1]];
    }
}