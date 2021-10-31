from django import forms


class Recoform(forms.Form):
    is_weekend = forms.ChoiceField(choices=[(1,'Yes'), (0,'No')], widget=forms.RadioSelect())
    number_of_ads = forms.IntegerField(min_value =0, max_value=20)
    spend_on_ads = forms.IntegerField( min_value=0, max_value=300)
    spend_on_platform_A = forms.IntegerField(min_value=0, max_value=600)
    spend_on_platform_B = forms.IntegerField(min_value=0, max_value=600)
    spend_on_platform_C = forms.IntegerField(min_value=0, max_value=600)
    expected_cost_per_click = forms.FloatField(min_value= 0, max_value=10)
