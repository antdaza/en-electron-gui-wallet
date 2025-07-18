<template>
  <q-page class="full-node-page">
    <div class="header row items-center justify-center q-pt-md">
      <q-btn-toggle
        v-model="screen"
        toggle-color="primary"
        color="accent"
        :options="[
          {
            label: $t('titles.fullNode.myStakes'),
            value: 'myStakes'
          },
          {
            label: $t('titles.fullNode.staking'),
            value: 'staking'
          },
          {
            label: $t('titles.fullNode.registration'),
            value: 'registration'
          }
        ]"
      />
    </div>
    <FullNodeUnlock v-if="screen === 'myStakes'" />
    <FullNodeStaking v-if="screen === 'staking'" />
    <FullNodeRegistration v-if="screen === 'registration'" />
  </q-page>
</template>

<script>
import FullNodeStaking from "components/full_node/full_node_staking";
import FullNodeRegistration from "components/full_node/full_node_registration";
import FullNodeUnlock from "components/full_node/full_node_unlock";
export default {
  components: {
    FullNodeStaking,
    FullNodeRegistration,
    FullNodeUnlock
  },
  data() {
    return {
      screen: "staking"
    };
  }
};
</script>

<style lang="scss"></style>
