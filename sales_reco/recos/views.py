from django.shortcuts import render,HttpResponse
from django.views.generic import TemplateView
from recos.forms import Recoform
import pandas as pd
from pickle import load

# Create your views here.
from django.http import HttpResponse


def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")

class RecoView(TemplateView):
    template_name = 'reco.html'

    def get(self, request):
        form = Recoform()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = Recoform(request.POST)
        if form.is_valid():
            model = load(open('recos/ml_files/model.pkl', 'rb'))
            results = self.getRecommendations(model, form.cleaned_data['is_weekend'], form.cleaned_data['number_of_ads'],
                                             form.cleaned_data['spend_on_ads'], form.cleaned_data['spend_on_platform_A'],
                                             form.cleaned_data['spend_on_platform_B'], form.cleaned_data['spend_on_platform_C'],
                                              form.cleaned_data['expected_cost_per_click'])
        context ={'form': form, 'result': results}
        print(context)

        return render(request, self.template_name, context)

    def getRecommendations(self, model, is_weekend, number_of_ads, spend_on_ads, spend_on_platform_A, spend_on_platform_B,spend_on_platform_C, cost_per_click):

        prediction_dataset = pd.DataFrame(columns=['is_weekend','no_of_ads','cost_per_click', 'Platform A_spend',
       'Platform B_spend', 'Platform C_spend','ad_spend'])
        prediction_dataset.loc[0] =[is_weekend, number_of_ads, cost_per_click, spend_on_platform_A, spend_on_platform_B, spend_on_platform_C,spend_on_ads]
        # prediction_dataset['is_weekend'] = is_weekend
        # prediction_dataset['no_of_ads'] = number_of_ads
        # prediction_dataset['ad_spend'] = spend_on_ads
        # prediction_dataset['platform_promo_spend'] = spend_on_promotions
        print(prediction_dataset)
        scaler = load(open('recos/ml_files/scaler.pkl', 'rb'))
        X_test_scaled = scaler.transform(prediction_dataset)
        return round(model.predict(X_test_scaled)[0],2)

