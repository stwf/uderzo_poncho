defmodule UderzoExample.Thermostat do
  @moduledoc """
  A basic thermostat display, mostly fake, to show off Uderzo
  """
  use Clixir
  @clixir_header "thermostat"

  # A sample thermostat display.
  def temp(t) do
    # Fake the temperature
    25 * :math.sin(t / 10)
  end

  def tim_init() do
    base_dir = Application.app_dir(:uderzo_example, ".")
    priv_dir = Path.absname("priv", base_dir)

    create_font("sans", Path.join(priv_dir, "SourceCodePro-Regular.ttf"))
  end

  def_c create_font(name, file_name) do
    cdecl "char *": [name, file_name]
    cdecl int: retval

    assert(nvgCreateFont(vg, name, file_name) >= 0)
  end

  def tim_render(win_width, win_height, t) do
    inside = temp(t)
    outside = temp(t - 10)
    burn = inside < outside
    draw_inside_temp(inside, win_width, win_height)
    draw_outside_temp(outside, win_width, win_height)
    draw_burn_indicator(burn, win_width, win_height)
  end

  defp left_align(x), do: 0.1 * x
  defp display_temp(t), do: "#{:erlang.float_to_binary(t, [decimals: 1])}°C"

  def draw_inside_temp(temp, w, h) do
    left_align = left_align(w)
    draw_small_text("Inside temp", left_align, 0.1 * h)
    draw_big_text(display_temp(temp), left_align, 0.14 * h)
  end
  def draw_outside_temp(temp, w, h) do
    left_align = left_align(w)
    draw_small_text("Outside temp", left_align, 0.3 * h)
    draw_big_text(display_temp(temp), left_align, 0.34 * h)
  end
  def draw_burn_indicator(_burn = true, w, h), do: nil #show_flame(w, h)
  def draw_burn_indicator(_burn = false, _w, _h), do: nil

  def draw_small_text(t, x, y), do: draw_text(t, String.length(t), 16.0, x, y)
  def draw_big_text(t, x, y), do: draw_text(t, String.length(t), 40.0, x, y)

  def_c show_flame(w, h) do
    cdecl double: [w, h]
    fprintf(stderr, "Here is where we draw a flame..;")
  end

  def_c draw_text(t, tl, sz, x, y) do
    cdecl "char *": t
    cdecl long: tl
    cdecl double: [sz, x, y]

    nvgFontSize(vg, sz)
    nvgFontFace(vg, "sans")
    nvgTextAlign(vg, NVG_ALIGN_LEFT|NVG_ALIGN_TOP)
    nvgFillColor(vg, nvgRGBA(255, 255, 255, 255))
    nvgText(vg, x, y, t, t + tl)
  end
end
