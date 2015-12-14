class GameMenuButton : Control
{
    private ImageControl button;
    private string name;

    public GameMenuButton(string name)
    {
        base();
        this.name = name;
        selectable = true;
    }

    public override void added()
    {
        resize_style = ResizeStyle.ABSOLUTE;

        button = new ImageControl("Buttons/" + name);
        add_child(button);
        button.resize_style = ResizeStyle.RELATIVE;
        size = button.end_size;
    }

    public override void do_render(RenderState state, RenderScene2D scene)
    {
        if (!enabled)
        {
            button.diffuse_color = Color.with_alpha(0.05f);
        }
        else
        {
            if (hovering)
            {
                if (mouse_down)
                    button.diffuse_color = Color(0.3f, 0.3f, 0.1f, 1);
                else
                    button.diffuse_color = Color(0.5f, 0.5f, 0.3f, 1);
            }
            else
                button.diffuse_color = Color.with_alpha(1);
        }
    }
}
