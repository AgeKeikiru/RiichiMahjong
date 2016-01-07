class ScoringPlayerElement : Control
{
    private Wind wind;
    private string player_name;
    private int points;
    private int transfer;
    private int score;

    private LabelControl score_label;

    public ScoringPlayerElement(Wind wind, string player_name, int points, int transfer, int score)
    {
        this.wind = wind;
        this.player_name = player_name;
        this.points = points;
        this.transfer = transfer;
        this.score = score;
    }

    public override void added()
    {
        resize_style = ResizeStyle.ABSOLUTE;

        View2D container = new View2D();
        add_child(container);
        ImageControl background = new ImageControl("Menu/score_background");
        container.add_child(background);
        size = background.end_size;

        int padding = 10;
        LabelControl wind_label = new LabelControl();
        add_child(wind_label);
        wind_label.text = WIND_TO_STRING(wind);
        wind_label.inner_anchor = Vec2(0, 0.5f);
        wind_label.outer_anchor = Vec2(0, 0.5f);
        wind_label.font_size = 50;
        wind_label.position = Vec2(padding, 0);
        wind_label.color = Color.blue();

        LabelControl name_label = new LabelControl();
        add_child(name_label);
        name_label.text = player_name;
        name_label.font_size = 40;
        name_label.color = wind_label.color;
        name_label.inner_anchor = Vec2(0, 0);
        name_label.outer_anchor = Vec2(0, 0.5f);
        name_label.position = Vec2(wind_label.size.width + padding * 2, 0);

        LabelControl points_label = new LabelControl();
        add_child(points_label);
        points_label.text = points.to_string();
        points_label.font_size = 20;
        points_label.inner_anchor = Vec2(0, 1);
        points_label.outer_anchor = Vec2(0, 0.5f);
        points_label.position = Vec2(wind_label.size.width + padding * 2, 0);
        points_label.color = Color.white();

        LabelControl transfer_label = new LabelControl();
        add_child(transfer_label);
        transfer_label.inner_anchor = Vec2(0, 1);
        transfer_label.outer_anchor = Vec2(0, 0.5f);
        transfer_label.position = Vec2(wind_label.size.width + padding * 2 + points_label.size.width, 0);
        transfer_label.font_size = 20;
        if (transfer > 0)
        {
            transfer_label.text = " (+" + transfer.to_string() + ")";
            transfer_label.color = Color.green();
        }
        else if (transfer < 0)
        {
            transfer_label.text = " (-" + (-transfer).to_string() + ")";
            transfer_label.color = Color.red();
        }
        else
            transfer_label.visible = false;

        string score_text = score.to_string();
        if (score > 0)
            score_text = "+" + score_text;

        score_label = new LabelControl();
        add_child(score_label);
        score_label.text = score_text;
        score_label.font_size = 40;
        score_label.inner_anchor = Vec2(1, 0.5f);
        score_label.outer_anchor = Vec2(1, 0.5f);
        score_label.visible = false;
        score_label.position = Vec2(-10, 0);
        if (score >= 0)
            score_label.color = Color.white();
        else
            score_label.color = Color.red();
    }

    public bool show_score
    {
        get { return score_label.visible; }
        set { score_label.visible = value; }
    }
}
