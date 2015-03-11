/* MainMenuBackground.c generated by valac 0.12.0, the Vala compiler
 * generated from MainMenuBackground.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>


#define TYPE_VIEW (view_get_type ())
#define VIEW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_VIEW, View))
#define VIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_VIEW, ViewClass))
#define IS_VIEW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_VIEW))
#define IS_VIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_VIEW))
#define VIEW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_VIEW, ViewClass))

typedef struct _View View;
typedef struct _ViewClass ViewClass;
typedef struct _ViewPrivate ViewPrivate;

#define TYPE_IRESOURCE_STORE (iresource_store_get_type ())
#define IRESOURCE_STORE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_IRESOURCE_STORE, IResourceStore))
#define IS_IRESOURCE_STORE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_IRESOURCE_STORE))
#define IRESOURCE_STORE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), TYPE_IRESOURCE_STORE, IResourceStoreIface))

typedef struct _IResourceStore IResourceStore;
typedef struct _IResourceStoreIface IResourceStoreIface;

#define TYPE_RENDER3_DOBJECT (render3_dobject_get_type ())
#define RENDER3_DOBJECT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_RENDER3_DOBJECT, Render3DObject))
#define RENDER3_DOBJECT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_RENDER3_DOBJECT, Render3DObjectClass))
#define IS_RENDER3_DOBJECT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_RENDER3_DOBJECT))
#define IS_RENDER3_DOBJECT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_RENDER3_DOBJECT))
#define RENDER3_DOBJECT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_RENDER3_DOBJECT, Render3DObjectClass))

typedef struct _Render3DObject Render3DObject;
typedef struct _Render3DObjectClass Render3DObjectClass;

#define TYPE_RENDER_STATE (render_state_get_type ())
#define RENDER_STATE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_RENDER_STATE, RenderState))
#define RENDER_STATE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_RENDER_STATE, RenderStateClass))
#define IS_RENDER_STATE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_RENDER_STATE))
#define IS_RENDER_STATE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_RENDER_STATE))
#define RENDER_STATE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_RENDER_STATE, RenderStateClass))

typedef struct _RenderState RenderState;
typedef struct _RenderStateClass RenderStateClass;

#define TYPE_RENDER_WINDOW (render_window_get_type ())
#define RENDER_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_RENDER_WINDOW, RenderWindow))
#define RENDER_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_RENDER_WINDOW, RenderWindowClass))
#define IS_RENDER_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_RENDER_WINDOW))
#define IS_RENDER_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_RENDER_WINDOW))
#define RENDER_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_RENDER_WINDOW, RenderWindowClass))

typedef struct _RenderWindow RenderWindow;
typedef struct _RenderWindowClass RenderWindowClass;

#define TYPE_MAIN_MENU_BACKGROUND (main_menu_background_get_type ())
#define MAIN_MENU_BACKGROUND(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_MAIN_MENU_BACKGROUND, MainMenuBackground))
#define MAIN_MENU_BACKGROUND_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_MAIN_MENU_BACKGROUND, MainMenuBackgroundClass))
#define IS_MAIN_MENU_BACKGROUND(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_MAIN_MENU_BACKGROUND))
#define IS_MAIN_MENU_BACKGROUND_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_MAIN_MENU_BACKGROUND))
#define MAIN_MENU_BACKGROUND_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_MAIN_MENU_BACKGROUND, MainMenuBackgroundClass))

typedef struct _MainMenuBackground MainMenuBackground;
typedef struct _MainMenuBackgroundClass MainMenuBackgroundClass;
typedef struct _MainMenuBackgroundPrivate MainMenuBackgroundPrivate;
#define _render3_dobject_unref0(var) ((var == NULL) ? NULL : (var = (render3_dobject_unref (var), NULL)))

#define TYPE_VEC3 (vec3_get_type ())
typedef struct _Vec3 Vec3;

struct _IResourceStoreIface {
	GTypeInterface parent_iface;
	Render3DObject* (*load_3D_object) (IResourceStore* self, const gchar* name);
};

struct _View {
	GTypeInstance parent_instance;
	volatile int ref_count;
	ViewPrivate * priv;
	RenderWindow* parent_window;
};

struct _ViewClass {
	GTypeClass parent_class;
	void (*finalize) (View *self);
	void (*do_load_resources) (View* self, IResourceStore* store);
	void (*do_render) (View* self, RenderState* state, IResourceStore* store);
	void (*do_process) (View* self, gdouble dt);
	void (*do_mouse_move) (View* self, gint x, gint y);
	void (*do_key_press) (View* self, gchar key);
};

struct _MainMenuBackground {
	View parent_instance;
	MainMenuBackgroundPrivate * priv;
};

struct _MainMenuBackgroundClass {
	ViewClass parent_class;
};

struct _MainMenuBackgroundPrivate {
	gfloat rotation;
	Render3DObject* tile;
	Render3DObject* table;
	Render3DObject* field;
	gint last_x;
	gint last_y;
	gfloat accel_x;
	gfloat accel_y;
	gfloat accel_z;
	gfloat camera_x;
	gfloat camera_y;
	gfloat camera_z;
	gdouble derp;
};

struct _Vec3 {
	gfloat x;
	gfloat y;
	gfloat z;
};


static gpointer main_menu_background_parent_class = NULL;

gpointer view_ref (gpointer instance);
void view_unref (gpointer instance);
GParamSpec* param_spec_view (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void value_set_view (GValue* value, gpointer v_object);
void value_take_view (GValue* value, gpointer v_object);
gpointer value_get_view (const GValue* value);
GType view_get_type (void) G_GNUC_CONST;
gpointer render3_dobject_ref (gpointer instance);
void render3_dobject_unref (gpointer instance);
GParamSpec* param_spec_render3_dobject (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void value_set_render3_dobject (GValue* value, gpointer v_object);
void value_take_render3_dobject (GValue* value, gpointer v_object);
gpointer value_get_render3_dobject (const GValue* value);
GType render3_dobject_get_type (void) G_GNUC_CONST;
GType iresource_store_get_type (void) G_GNUC_CONST;
gpointer render_state_ref (gpointer instance);
void render_state_unref (gpointer instance);
GParamSpec* param_spec_render_state (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void value_set_render_state (GValue* value, gpointer v_object);
void value_take_render_state (GValue* value, gpointer v_object);
gpointer value_get_render_state (const GValue* value);
GType render_state_get_type (void) G_GNUC_CONST;
gpointer render_window_ref (gpointer instance);
void render_window_unref (gpointer instance);
GParamSpec* param_spec_render_window (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void value_set_render_window (GValue* value, gpointer v_object);
void value_take_render_window (GValue* value, gpointer v_object);
gpointer value_get_render_window (const GValue* value);
GType render_window_get_type (void) G_GNUC_CONST;
GType main_menu_background_get_type (void) G_GNUC_CONST;
#define MAIN_MENU_BACKGROUND_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), TYPE_MAIN_MENU_BACKGROUND, MainMenuBackgroundPrivate))
enum  {
	MAIN_MENU_BACKGROUND_DUMMY_PROPERTY
};
MainMenuBackground* main_menu_background_new (void);
MainMenuBackground* main_menu_background_construct (GType object_type);
View* view_construct (GType object_type);
static void main_menu_background_real_do_load_resources (View* base, IResourceStore* store);
Render3DObject* iresource_store_load_3D_object (IResourceStore* self, const gchar* name);
GType vec3_get_type (void) G_GNUC_CONST;
Vec3* vec3_dup (const Vec3* self);
void vec3_free (Vec3* self);
void render3_dobject_set_position (Render3DObject* self, Vec3* value);
void render3_dobject_set_scale (Render3DObject* self, Vec3* value);
static void main_menu_background_real_do_process (View* base, gdouble dt);
static void main_menu_background_real_do_render (View* base, RenderState* state, IResourceStore* store);
void render_state_set_camera_rotation (RenderState* self, Vec3* value);
void render_state_set_camera_position (RenderState* self, Vec3* value);
void render_state_add_3D_object (RenderState* self, Render3DObject* object);
static void main_menu_background_real_do_mouse_move (View* base, gint x, gint y);
static void main_menu_background_real_do_key_press (View* base, gchar key);
static void main_menu_background_finalize (View* obj);


MainMenuBackground* main_menu_background_construct (GType object_type) {
	MainMenuBackground* self = NULL;
	self = (MainMenuBackground*) view_construct (object_type);
	return self;
}


MainMenuBackground* main_menu_background_new (void) {
	return main_menu_background_construct (TYPE_MAIN_MENU_BACKGROUND);
}


static void main_menu_background_real_do_load_resources (View* base, IResourceStore* store) {
	MainMenuBackground * self;
	Render3DObject* _tmp0_ = NULL;
	Render3DObject* _tmp1_ = NULL;
	Render3DObject* _tmp2_ = NULL;
	Vec3 _tmp3_ = {0};
	Vec3 _tmp4_ = {0};
	Vec3 _tmp5_ = {0};
	Vec3 _tmp6_ = {0};
	Vec3 _tmp7_ = {0};
	Vec3 _tmp8_ = {0};
	Vec3 _tmp9_ = {0};
	Vec3 _tmp10_ = {0};
	Vec3 _tmp11_ = {0};
	Vec3 _tmp12_ = {0};
	Vec3 _tmp13_ = {0};
	Vec3 _tmp14_ = {0};
	self = (MainMenuBackground*) base;
	g_return_if_fail (store != NULL);
	_tmp0_ = iresource_store_load_3D_object (store, "./3d/table");
	_render3_dobject_unref0 (self->priv->table);
	self->priv->table = _tmp0_;
	_tmp1_ = iresource_store_load_3D_object (store, "./3d/box");
	_render3_dobject_unref0 (self->priv->tile);
	self->priv->tile = _tmp1_;
	_tmp2_ = iresource_store_load_3D_object (store, "./3d/field");
	_render3_dobject_unref0 (self->priv->field);
	self->priv->field = _tmp2_;
	memset (&_tmp3_, 0, sizeof (Vec3));
	_tmp3_.y = -0.163f;
	_tmp4_ = _tmp3_;
	render3_dobject_set_position (self->priv->table, &_tmp4_);
	memset (&_tmp5_, 0, sizeof (Vec3));
	_tmp5_.x = (gfloat) 10;
	_tmp5_.y = (gfloat) 10;
	_tmp5_.z = (gfloat) 10;
	_tmp6_ = _tmp5_;
	render3_dobject_set_scale (self->priv->table, &_tmp6_);
	memset (&_tmp7_, 0, sizeof (Vec3));
	_tmp7_.y = 12.5f;
	_tmp8_ = _tmp7_;
	render3_dobject_set_position (self->priv->tile, &_tmp8_);
	memset (&_tmp9_, 0, sizeof (Vec3));
	_tmp9_.x = 1.0f;
	_tmp9_.y = 1.0f;
	_tmp9_.z = 1.0f;
	_tmp10_ = _tmp9_;
	render3_dobject_set_scale (self->priv->tile, &_tmp10_);
	memset (&_tmp11_, 0, sizeof (Vec3));
	_tmp11_.y = 12.4f;
	_tmp12_ = _tmp11_;
	render3_dobject_set_position (self->priv->field, &_tmp12_);
	memset (&_tmp13_, 0, sizeof (Vec3));
	_tmp13_.x = 9.6f;
	_tmp13_.z = 9.6f;
	_tmp14_ = _tmp13_;
	render3_dobject_set_scale (self->priv->field, &_tmp14_);
}


static void main_menu_background_real_do_process (View* base, gdouble dt) {
	MainMenuBackground * self;
	gint slow;
	self = (MainMenuBackground*) base;
	self->priv->derp = self->priv->derp + dt;
	slow = 300;
	self->priv->camera_x = self->priv->camera_x + self->priv->accel_x;
	self->priv->camera_y = self->priv->camera_y + self->priv->accel_y;
	self->priv->camera_z = self->priv->camera_z + self->priv->accel_z;
}


static void main_menu_background_real_do_render (View* base, RenderState* state, IResourceStore* store) {
	MainMenuBackground * self;
	gint slow;
	Vec3 _tmp0_ = {0};
	Vec3 _tmp1_ = {0};
	Vec3 _tmp2_ = {0};
	Vec3 _tmp3_ = {0};
	self = (MainMenuBackground*) base;
	g_return_if_fail (state != NULL);
	g_return_if_fail (store != NULL);
	slow = 300;
	memset (&_tmp0_, 0, sizeof (Vec3));
	_tmp0_.x = 1 - (((gfloat) self->priv->last_y) / slow);
	_tmp0_.y = (-((gfloat) self->priv->last_x)) / slow;
	_tmp1_ = _tmp0_;
	render_state_set_camera_rotation (state, &_tmp1_);
	memset (&_tmp2_, 0, sizeof (Vec3));
	_tmp2_.x = self->priv->camera_x;
	_tmp2_.y = self->priv->camera_y;
	_tmp2_.z = self->priv->camera_z;
	_tmp3_ = _tmp2_;
	render_state_set_camera_position (state, &_tmp3_);
	render_state_add_3D_object (state, self->priv->tile);
	render_state_add_3D_object (state, self->priv->table);
	render_state_add_3D_object (state, self->priv->field);
}


static void main_menu_background_real_do_mouse_move (View* base, gint x, gint y) {
	MainMenuBackground * self;
	self = (MainMenuBackground*) base;
	self->priv->last_x = x;
	self->priv->last_y = y;
}


static void main_menu_background_real_do_key_press (View* base, gchar key) {
	MainMenuBackground * self;
	gint slow;
	gfloat speed;
	self = (MainMenuBackground*) base;
	slow = 300;
	speed = 0.001f;
	switch (key) {
		case ' ':
		{
			self->priv->accel_y = self->priv->accel_y + speed;
			break;
		}
		case 'c':
		{
			self->priv->accel_y = self->priv->accel_y - speed;
			break;
		}
		case 'w':
		{
			gdouble _tmp0_;
			gdouble _tmp1_;
			gdouble _tmp2_;
			gdouble _tmp3_;
			gdouble _tmp4_;
			_tmp0_ = cos ((((gfloat) self->priv->last_x) / slow) * G_PI);
			_tmp1_ = cos ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_z = self->priv->accel_z + ((((gfloat) _tmp0_) * ((gfloat) _tmp1_)) * speed);
			_tmp2_ = sin ((((gfloat) self->priv->last_x) / slow) * G_PI);
			_tmp3_ = cos ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_x = self->priv->accel_x + ((((gfloat) _tmp2_) * ((gfloat) _tmp3_)) * speed);
			_tmp4_ = sin ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_y = self->priv->accel_y + (((gfloat) _tmp4_) * speed);
			break;
		}
		case 's':
		{
			gdouble _tmp5_;
			gdouble _tmp6_;
			gdouble _tmp7_;
			gdouble _tmp8_;
			gdouble _tmp9_;
			_tmp5_ = cos ((((gfloat) self->priv->last_x) / slow) * G_PI);
			_tmp6_ = cos ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_z = self->priv->accel_z - ((((gfloat) _tmp5_) * ((gfloat) _tmp6_)) * speed);
			_tmp7_ = sin ((((gfloat) self->priv->last_x) / slow) * G_PI);
			_tmp8_ = cos ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_x = self->priv->accel_x - ((((gfloat) _tmp7_) * ((gfloat) _tmp8_)) * speed);
			_tmp9_ = sin ((((gfloat) self->priv->last_y) / slow) * G_PI);
			self->priv->accel_y = self->priv->accel_y - (((gfloat) _tmp9_) * speed);
			break;
		}
		case 'a':
		{
			gdouble _tmp10_;
			gdouble _tmp11_;
			_tmp10_ = sin ((((gfloat) self->priv->last_x) / slow) * G_PI);
			self->priv->accel_z = self->priv->accel_z - (((gfloat) _tmp10_) * speed);
			_tmp11_ = cos ((((gfloat) self->priv->last_x) / slow) * G_PI);
			self->priv->accel_x = self->priv->accel_x + (((gfloat) _tmp11_) * speed);
			break;
		}
		case 'd':
		{
			gdouble _tmp12_;
			gdouble _tmp13_;
			_tmp12_ = sin ((((gfloat) self->priv->last_x) / slow) * G_PI);
			self->priv->accel_z = self->priv->accel_z + (((gfloat) _tmp12_) * speed);
			_tmp13_ = cos ((((gfloat) self->priv->last_x) / slow) * G_PI);
			self->priv->accel_x = self->priv->accel_x - (((gfloat) _tmp13_) * speed);
			break;
		}
		case 'x':
		{
			self->priv->accel_x = (gfloat) 0;
			self->priv->accel_y = (gfloat) 0;
			self->priv->accel_z = (gfloat) 0;
			break;
		}
		default:
		{
			g_print ("%i\n", (gint) key);
			break;
		}
	}
}


static void main_menu_background_class_init (MainMenuBackgroundClass * klass) {
	main_menu_background_parent_class = g_type_class_peek_parent (klass);
	VIEW_CLASS (klass)->finalize = main_menu_background_finalize;
	g_type_class_add_private (klass, sizeof (MainMenuBackgroundPrivate));
	VIEW_CLASS (klass)->do_load_resources = main_menu_background_real_do_load_resources;
	VIEW_CLASS (klass)->do_process = main_menu_background_real_do_process;
	VIEW_CLASS (klass)->do_render = main_menu_background_real_do_render;
	VIEW_CLASS (klass)->do_mouse_move = main_menu_background_real_do_mouse_move;
	VIEW_CLASS (klass)->do_key_press = main_menu_background_real_do_key_press;
}


static void main_menu_background_instance_init (MainMenuBackground * self) {
	self->priv = MAIN_MENU_BACKGROUND_GET_PRIVATE (self);
	self->priv->rotation = (gfloat) 0;
	self->priv->tile = NULL;
	self->priv->table = NULL;
	self->priv->field = NULL;
	self->priv->last_x = 0;
	self->priv->last_y = 0;
	self->priv->accel_x = (gfloat) 0;
	self->priv->accel_y = (gfloat) 0;
	self->priv->accel_z = (gfloat) 0;
	self->priv->camera_x = (gfloat) 0;
	self->priv->camera_y = (gfloat) 0;
	self->priv->camera_z = (gfloat) 0;
	self->priv->derp = (gdouble) 0;
}


static void main_menu_background_finalize (View* obj) {
	MainMenuBackground * self;
	self = MAIN_MENU_BACKGROUND (obj);
	_render3_dobject_unref0 (self->priv->tile);
	_render3_dobject_unref0 (self->priv->table);
	_render3_dobject_unref0 (self->priv->field);
	VIEW_CLASS (main_menu_background_parent_class)->finalize (obj);
}


GType main_menu_background_get_type (void) {
	static volatile gsize main_menu_background_type_id__volatile = 0;
	if (g_once_init_enter (&main_menu_background_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (MainMenuBackgroundClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) main_menu_background_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (MainMenuBackground), 0, (GInstanceInitFunc) main_menu_background_instance_init, NULL };
		GType main_menu_background_type_id;
		main_menu_background_type_id = g_type_register_static (TYPE_VIEW, "MainMenuBackground", &g_define_type_info, 0);
		g_once_init_leave (&main_menu_background_type_id__volatile, main_menu_background_type_id);
	}
	return main_menu_background_type_id__volatile;
}



